// Copyright (c) 2022, Luis Ciber
// https://luisciber.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tflite_style_transfer_platform_interface/src/method_channel_tflite_style_transfer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const kPlatformName = 'platformName';
  const kGeneratedPath = 'some_path/generated_image.png';

  group('$MethodChannelTfliteStyleTransfer', () {
    late MethodChannelTfliteStyleTransfer methodChannelTfliteStyleTransfer;
    final log = <MethodCall>[];

    setUp(() async {
      methodChannelTfliteStyleTransfer = MethodChannelTfliteStyleTransfer()
        ..methodChannel.setMockMethodCallHandler((MethodCall methodCall) async {
          log.add(methodCall);
          switch (methodCall.method) {
            case 'getPlatformName':
              return kPlatformName;
            case 'runStyleTransfer':
              return kGeneratedPath;
            default:
              return null;
          }
        });
    });

    tearDown(log.clear);

    test('getPlatformName', () async {
      final platformName =
          await methodChannelTfliteStyleTransfer.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(platformName, equals(kPlatformName));
    });

    test('runStyleTransfer', () async {
      final platformName =
          await methodChannelTfliteStyleTransfer.runStyleTransfer(
        imagePath: 'imagePath',
        styleImagePath: 'styleImagePath',
        styleFromAssets: true,
      );

      expect(
        log,
        <Matcher>[
          isMethodCall(
            'runStyleTransfer',
            arguments: {
              'styleImagePath': 'styleImagePath',
              'imagePath': 'imagePath',
              'styleFromAssets': true,
            },
          ),
        ],
      );
      expect(platformName, equals(kGeneratedPath));
    });
  });
}
