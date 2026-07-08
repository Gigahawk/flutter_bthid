package com.gigahawk.flutter_bthid

import android.bluetooth.BluetoothHidDevice
import android.bluetooth.BluetoothHidDeviceAppQosSettings
import android.bluetooth.BluetoothHidDeviceAppSdpSettings
import android.bluetooth.BluetoothDevice as AndroidBluetoothDevice
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothProfile
import android.content.Context
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin

import com.gigahawk.flutter_bthid.gen.BluetoothDeviceInfo
import com.gigahawk.flutter_bthid.gen.FlutterBthidApi
import com.gigahawk.flutter_bthid.gen.BluetoothEventsApi
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withTimeoutOrNull

private fun AndroidBluetoothDevice.toInfo(): BluetoothDeviceInfo {
    return BluetoothDeviceInfo (
        name = this.name,
        deviceClass = getDeviceClassName(this.bluetoothClass.deviceClass),
        address = this.address
    )
}

class FlutterBthidPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val context = binding.applicationContext
        val eventsApi = BluetoothEventsApi(binding.binaryMessenger)
        FlutterBthidApi.setUp(binding.binaryMessenger, FlutterBthidApiImplementation(context, eventsApi))
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}
}

private class FlutterBthidApiImplementation(
    private val context: Context,
    private val eventsApi: BluetoothEventsApi
) : FlutterBthidApi {

    private val tag = "FlutterBthidApiImpl"

    private val bluetoothManager = context.getSystemService(BluetoothManager::class.java)
    private val adapter = bluetoothManager.adapter

    private var hidDevice: BluetoothHidDevice? = null
    private var targetDevice: AndroidBluetoothDevice? = null
        set(value) {
            field = value
            eventsApi.onConnectionStateChanged(value?.toInfo()) {}
        }

    private val _callback =
        object : BluetoothHidDevice.Callback() {
            override fun onConnectionStateChanged(device: AndroidBluetoothDevice?, state: Int) {
                Log.d(tag, "onConnectionStateChanged: ${device?.name}, $state")
                when (state) {
                    BluetoothHidDevice.STATE_CONNECTED -> {
                        Log.d(tag, "STATE_CONNECTED")
                        targetDevice = device
                    }
                    BluetoothHidDevice.STATE_DISCONNECTED -> {
                        Log.d(tag, "STATE_DISCONNECTED")
                        targetDevice = null
                    }
                    BluetoothHidDevice.STATE_DISCONNECTING -> {
                        Log.d(tag, "STATE_DISCONNECTING")
                        //targetDevice = null
                    }
                }
                super.onConnectionStateChanged(device, state)
            }

            override fun onAppStatusChanged(pluggedDevice: AndroidBluetoothDevice?, registered: Boolean) {
                Log.d(tag, "onAppStatusChanged: ${pluggedDevice?.name}, $registered")
                super.onAppStatusChanged(pluggedDevice, registered)
            }
        }

    private var sdpName: String = "flutter_bthid"
    private var sdpDescription: String = "Emulated Bluetooth HID Device"
    private var sdpProvider: String = "Gigahawk"

    private fun sdpSettings(): BluetoothHidDeviceAppSdpSettings {
        return BluetoothHidDeviceAppSdpSettings(
            sdpName,
            sdpDescription,
            sdpProvider,
            // TODO: is this required?
            //BluetoothHidDevice.SUBCLASS1_COMBO,
            BluetoothHidDevice.SUBCLASS1_KEYBOARD,
            DescriptorCollection.KEYBOARD,
        )
    }

    private fun qosSettings(): BluetoothHidDeviceAppQosSettings {
        // TODO: Make this configurable?
        return BluetoothHidDeviceAppQosSettings(
            BluetoothHidDeviceAppQosSettings.SERVICE_BEST_EFFORT,
            800,
            9,
            0,
            11250,
            BluetoothHidDeviceAppQosSettings.MAX,
        )
    }

    private fun getDevice(device: BluetoothDeviceInfo): AndroidBluetoothDevice? {
        return adapter.bondedDevices.firstOrNull {
            it.name == device.name && it.address == device.address
        }
    }

    override fun getPairedDevices(callback: (Result<List<BluetoothDeviceInfo>?>) -> Unit) {
        if (adapter == null){
            // TODO: failure?
            callback(Result.success(emptyList()))
            return
        }
        callback(Result.success(adapter.bondedDevices.toList().map {device -> device.toInfo()}))
    }

    // TODO: support setting sdp and qos settings
    override fun init(callback: (Result<Unit>) -> Unit) {
        adapter.getProfileProxy(
            context,
            object : BluetoothProfile.ServiceListener {
                override fun onServiceConnected(profile: Int, proxy: BluetoothProfile?) {
                    Log.d(tag, "Service Connected, profile: $profile")
                    hidDevice = proxy as? BluetoothHidDevice

                    hidDevice?.let { hd ->
                        if (hd.connectedDevices.isNotEmpty()) {
                            // TODO: What do the other index names contain?
                            Log.d(tag, "Found already connected device: ${hd.connectedDevices[0].name}")
                            targetDevice = hd.connectedDevices[0]
                        }

                        if (hd.connectedDevices.size > 1) {
                            Log.d(tag, "Found more than one connected device: ${hd.connectedDevices.map { it.name }}")
                            for (device in hd.connectedDevices) {
                                if (targetDevice != device) {
                                    Log.d(tag, "Disconnecting device: ${device.name}")
                                    hd.disconnect(device)
                                }
                            }
                        }

                        Log.d(tag, "Calling registerApp")
                        val result = hd.registerApp(
                            sdpSettings(),
                            null,
                            qosSettings(),
                            context.getMainExecutor(),
                            _callback,
                        )

                        if (result) {
                            Log.d(tag, "Successfully registered app")
                        } else {
                            Log.d(tag, "Failed to register app")
                        }
                    } ?: run {
                        Log.d(tag, "hidDevice is null")
                    }
                }

                override fun onServiceDisconnected(profile: Int) {
                    Log.d(tag, "Service Disconnected, profile: $profile")
                    hidDevice = null
                }
            },
            BluetoothProfile.HID_DEVICE,
        )
        callback(Result.success(Unit))
    }

    override fun connect(device: BluetoothDeviceInfo, callback: (Result<Unit>) -> Unit) {
        Log.d(tag, "Attemting to connect to ${device.name} with address ${device.address}")
        val androidDevice = getDevice(device)
        androidDevice?.let { d ->
            Log.d(tag, "Device found, attempting to connect")

            hidDevice?.let { hd ->
                CoroutineScope(Dispatchers.Default).launch {
                    // TODO: Only one device connection at a time is supported for now
                    // What does it even mean for a keyboard to be simultaneously connected to
                    // multiple devices? keystrokes are sent to all connected devices?
                    // What about capslock state being different??
                    if (targetDevice != null) {
                        Log.d(tag, "Disconnecting from already connected device ${targetDevice?.name}")
                        hd.disconnect(targetDevice)
                        Log.d(tag, "Waiting for device to disconnect")

                        val success = withTimeoutOrNull(5000) {
                            while (targetDevice!=null) {
                                delay(100)
                            }
                            true
                        }
                        if (success == null) {
                            Log.d(tag, "Could not disconnect from device after 5s")
                            callback(Result.failure(Exception("Could not disconnect from device after 5s")))
                            return@launch
                        }
                        Log.d(tag, "Device disconnected")
                    }

                    val result = hd.connect(d)
                    if (!result) {
                        Log.d(tag, "Connect request rejected")
                        callback(Result.failure(Exception("Connect request rejected")))
                    }
                    callback(Result.success(Unit))

                }
            } ?: {
                Log.d(tag, "hidDevice is null")
                callback(Result.failure(Exception("hidDevice is null")))
            }
        } ?: run {
            Log.d(tag, "Device not found")
            callback(Result.failure(Exception("Device not found")))
        }
    }

    override fun getConnectedDevice(callback: (Result<BluetoothDeviceInfo?>) -> Unit) {
        callback(Result.success(targetDevice?.toInfo()))
    }

    override fun sendReport(
        data: List<Long>,
        callback: (Result<Unit>) -> Unit
    ) {
        if (hidDevice == null) {
            callback(Result.failure(Exception("hidDevice is null")));
            return
        }
        if (targetDevice == null) {
            callback(Result.failure(Exception("targetDevice is null")));
            return
        }
        val reportData = ByteArray(data.size)
        data.forEachIndexed { index, value ->
            if (value > 255 || value < 0) {
                Log.d(tag, "Invalid value at index $index: $value")
                callback(Result.failure(Exception("Invalid value at index $index: $value")))
                return
            }
            reportData[index] = value.toByte()
        }

        // TODO: this is hardcoded to 1 for some reason??? Something to do with HID descriptor
        val success = hidDevice!!.sendReport(targetDevice, 0, reportData)

        if (success) {
            Log.d(tag, "Successfully sent report")
            callback(Result.success(Unit))
        } else {
            Log.e(tag, "Failed to send HID report")
            callback(Result.failure(Exception("Failed to send HID report")))
        }
    }
}
