package com.gigahawk.flutter_bthid

import android.bluetooth.BluetoothDevice as AndroidBluetoothDevice
import android.bluetooth.BluetoothManager
import android.content.Context
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
    override fun getPairedDevices(callback: (Result<List<BluetoothDeviceInfo>?>) -> Unit) {
        val adapter = context.getSystemService(BluetoothManager::class.java).adapter
        if (adapter == null){
            // TODO: failure?
            callback(Result.success(emptyList()))
            return
        }
        callback(Result.success(adapter.bondedDevices.toList().map {device -> device.toInfo()}))
    }
}