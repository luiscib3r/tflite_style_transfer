// Copyright (c) 2022, Luis Ciber
// https://luisciber.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tflite_style_transfer_ios/tflite_style_transfer_ios.dart';
import 'package:tflite_style_transfer_platform_interface/tflite_style_transfer_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TfliteStyleTransferIOS', () {
    const kPlatformName = 'iOS';
    late TfliteStyleTransferIOS tfliteStyleTransfer;
    late List<MethodCall> log;

    setUp(() async {
      tfliteStyleTransfer = TfliteStyleTransferIOS();

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
      TfliteStyleTransferIOS.registerWith();
      expect(
        TfliteStyleTransferPlatform.instance,
        isA<TfliteStyleTransferIOS>(),
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
