// Copyright (c) 2022, Luis Ciber
// https://luisciber.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tflite_style_transfer_android/tflite_style_transfer_android.dart';
import 'package:tflite_style_transfer_platform_interface/tflite_style_transfer_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TfliteStyleTransferAndroid', () {
    const kPlatformName = 'Android';
    late TfliteStyleTransferAndroid tfliteStyleTransfer;
    late List<MethodCall> log;

    setUp(() async {
      tfliteStyleTransfer = TfliteStyleTransferAndroid();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
          .setMockMethodCallHandler(tfliteStyleTransfer.methodChannel,
              (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getPlatformName':
            return kPlatformName;
          default:
            return null;
        }
      });
    });

    test('can be registered', () {
      TfliteStyleTransferAndroid.registerWith();
      expect(
        TfliteStyleTransferPlatform.instance,
        isA<TfliteStyleTransferAndroid>(),
      );
    });

    test('getPlatformName returns correct name', () async {
      final name = await tfliteStyleTransfer.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(name, equals(kPlatformName));
    });
  });
}
