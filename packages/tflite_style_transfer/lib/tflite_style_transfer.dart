// Copyright (c) 2022, Luis Ciber
// https://luisciber.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:tflite_style_transfer_platform_interface/tflite_style_transfer_platform_interface.dart';

TfliteStyleTransferPlatform get _platform =>
    TfliteStyleTransferPlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null) throw Exception('Unable to get platform name.');
  return platformName;
}

/// [TFLiteStyleTransfer]
class TFLiteStyleTransfer {
  /// Run style transfer model
  ///
  /// Returns the path of generated image
  ///
  /// `styleImagePath`: path of the style image
  ///
  /// `imagePath`: path of de original image
  ///
  /// `styleFromAssets`: set to true if your style image is an asset
  /// of your app
  ///
  Future<String?> runStyleTransfer({
    required String styleImagePath,
    required String imagePath,
    bool styleFromAssets = false,
  }) async {
    final result = await _platform.runStyleTransfer(
      styleImagePath: styleImagePath,
      imagePath: imagePath,
      styleFromAssets: styleFromAssets,
    );

    if (result == null) throw Exception('Unable to run style transfer.');
    return result;
  }
}
