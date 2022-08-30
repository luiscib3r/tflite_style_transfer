// Copyright (c) 2022, Luis Ciber
// https://luisciber.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tflite_style_transfer/tflite_style_transfer.dart';
import 'package:tflite_style_transfer_platform_interface/tflite_style_transfer_platform_interface.dart';

class MockTfliteStyleTransferPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements TfliteStyleTransferPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TfliteStyleTransfer', () {
    late TfliteStyleTransferPlatform tfliteStyleTransferPlatform;
    late TFLiteStyleTransfer tfLiteStyleTransfer;

    setUp(() {
      tfliteStyleTransferPlatform = MockTfliteStyleTransferPlatform();
      tfLiteStyleTransfer = TFLiteStyleTransfer();
      TfliteStyleTransferPlatform.instance = tfliteStyleTransferPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = '__test_platform__';
        when(
          () => tfliteStyleTransferPlatform.getPlatformName(),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await getPlatformName();
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => tfliteStyleTransferPlatform.getPlatformName(),
        ).thenAnswer((_) async => null);

        expect(getPlatformName, throwsException);
      });
    });

    group('runStyleTransfer', () {
      test('returns generated image path when platform implementation exists',
          () async {
        const generatedPath = 'some_path/generated.png';
        when(
          () => tfliteStyleTransferPlatform.runStyleTransfer(
            imagePath: any(named: 'imagePath'),
            styleImagePath: any(named: 'styleImagePath'),
            styleFromAssets: any(named: 'styleFromAssets'),
          ),
        ).thenAnswer((_) async => generatedPath);

        final result = await tfliteStyleTransferPlatform.runStyleTransfer(
          imagePath: 'imagePath',
          styleImagePath: 'styleImagePath',
          styleFromAssets: true,
        );

        expect(result, equals(generatedPath));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => tfliteStyleTransferPlatform.runStyleTransfer(
            imagePath: any(named: 'imagePath'),
            styleImagePath: any(named: 'styleImagePath'),
            styleFromAssets: any(named: 'styleFromAssets'),
          ),
        ).thenAnswer((_) async => null);

        expect(
          tfLiteStyleTransfer.runStyleTransfer(
            imagePath: 'imagePath',
            styleImagePath: 'styleImagePath',
            styleFromAssets: true,
          ),
          throwsException,
        );
      });
    });
  });
}
