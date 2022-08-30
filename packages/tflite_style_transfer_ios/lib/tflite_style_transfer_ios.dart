// Copyright (c) 2022, Luis Ciber
// https://luisciber.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_style_transfer_platform_interface/tflite_style_transfer_platform_interface.dart';

/// The iOS implementation of [TfliteStyleTransferPlatform].
class TfliteStyleTransferIOS extends TfliteStyleTransferPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tflite_style_transfer_ios');

  /// Registers this class as the default instance of
  /// [TfliteStyleTransferPlatform]
  static void registerWith() {
    TfliteStyleTransferPlatform.instance = TfliteStyleTransferIOS();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
