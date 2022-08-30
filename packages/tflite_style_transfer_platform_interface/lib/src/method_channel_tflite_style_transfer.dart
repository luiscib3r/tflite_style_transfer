// Copyright (c) 2022, Luis Ciber
// https://luisciber.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:tflite_style_transfer_platform_interface/tflite_style_transfer_platform_interface.dart';

/// An implementation of [TfliteStyleTransferPlatform] that uses method
/// channels.
class MethodChannelTfliteStyleTransfer extends TfliteStyleTransferPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tflite_style_transfer');

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }

  @override
  Future<String?> runStyleTransfer({
    required String styleImagePath,
    required String imagePath,
    required bool styleFromAssets,
  }) async {
    final result = await methodChannel.invokeMethod<String?>(
      'runStyleTransfer',
      {
        'styleImagePath': styleImagePath,
        'imagePath': imagePath,
        'styleFromAssets': styleFromAssets,
      },
    );

    return result;
  }
}
