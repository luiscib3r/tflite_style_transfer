// Copyright (c) 2022, Luis Ciber
// https://luisciber.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tflite_style_transfer_platform_interface/src/method_channel_tflite_style_transfer.dart';

/// The interface that implementations of tflite_style_transfer must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `TfliteStyleTransfer`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
/// this interface will be broken by newly added [TfliteStyleTransferPlatform]
/// methods.
abstract class TfliteStyleTransferPlatform extends PlatformInterface {
  /// Constructs a TfliteStyleTransferPlatform.
  TfliteStyleTransferPlatform() : super(token: _token);

  static final Object _token = Object();

  static TfliteStyleTransferPlatform _instance =
      MethodChannelTfliteStyleTransfer();

  /// The default instance of [TfliteStyleTransferPlatform] to use.
  ///
  /// Defaults to [MethodChannelTfliteStyleTransfer].
  static TfliteStyleTransferPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [TfliteStyleTransferPlatform] when they register
  /// themselves.
  static set instance(TfliteStyleTransferPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<String?> getPlatformName();
}
