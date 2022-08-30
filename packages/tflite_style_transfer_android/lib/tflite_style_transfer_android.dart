// Copyright (c) 2022, Luis Ciber
// https://luisciber.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_style_transfer_platform_interface/tflite_style_transfer_platform_interface.dart';

/// The Android implementation of [TfliteStyleTransferPlatform].
class TfliteStyleTransferAndroid extends TfliteStyleTransferPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tflite_style_transfer_android');

  /// Registers this class as the default instance of
  /// [TfliteStyleTransferPlatform]
  static void registerWith() {
    TfliteStyleTransferPlatform.instance = TfliteStyleTransferAndroid();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }

  @override
  Future<String?> runStyleTransfer({
    required String styleImagePath,
    required String imagePath,
    required bool styleFromAssets,
  }) {
    return methodChannel.invokeMethod<String?>(
      'runStyleTransfer',
      {
        'styleImagePath': styleImagePath,
        'imagePath': imagePath,
        'styleFromAssets': styleFromAssets,
      },
    );
  }
}
