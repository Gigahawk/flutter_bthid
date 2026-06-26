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
        FlutterBthidApi.setUp(binding.binaryMessenger, FlutterBthidApiImplementation(context))
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}
}

private class FlutterBthidApiImplementation(
    private val context: Context
) : FlutterBthidApi {

    private val tag = "FlutterBthidApiImpl"

    private val bluetoothManager = context.getSystemService(BluetoothManager::class.java)
    private val adapter = bluetoothManager.adapter

    private var hidDevice: BluetoothHidDevice? = null
    private var targetDevice: AndroidBluetoothDevice? = null

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
                        val connected = hd.connectedDevices;
                        if (connected.isNotEmpty()) {
                            // TODO: What do the other index names contain?
                            Log.d(tag, "Found already connected device: ${connected[0].name}")
                            targetDevice = connected[0]
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

}