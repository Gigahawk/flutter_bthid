package com.gigahawk.flutter_bthid

import android.bluetooth.BluetoothClass

fun getDeviceClassName(deviceClass: Int): String {
  return BluetoothClass.Device::class.java.fields
    .firstOrNull {
      it.type == Int::class.javaPrimitiveType &&
          it.getInt(null) == deviceClass
    }?.name
    ?: "UNKNOWN"
}
