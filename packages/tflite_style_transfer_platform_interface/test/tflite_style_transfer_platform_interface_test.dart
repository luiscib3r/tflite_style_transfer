// Copyright (c) 2022, Luis Ciber
// https://luisciber.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:tflite_style_transfer_platform_interface/tflite_style_transfer_platform_interface.dart';

class TfliteStyleTransferMock extends TfliteStyleTransferPlatform {
  static const mockPlatformName = 'Mock';
  static const mockGeneratedPath = 'some_path/generated.png';

  @override
  Future<String?> getPlatformName() async => mockPlatformName;

  @override
  Future<String?> runStyleTransfer({
    required String styleImagePath,
    required String imagePath,
    required bool styleFromAssets,
  }) async =>
      mockGeneratedPath;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('TfliteStyleTransferPlatformInterface', () {
    late TfliteStyleTransferPlatform tfliteStyleTransferPlatform;

    setUp(() {
      tfliteStyleTransferPlatform = TfliteStyleTransferMock();
      TfliteStyleTransferPlatform.instance = tfliteStyleTransferPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await TfliteStyleTransferPlatform.instance.getPlatformName(),
          equals(TfliteStyleTransferMock.mockPlatformName),
        );
      });
    });

    group('runStyleTransfer', () {
      test('returns path of generated image', () async {
        expect(
          await TfliteStyleTransferPlatform.instance.runStyleTransfer(
            imagePath: 'imagePath',
            styleImagePath: 'styleImagePath',
            styleFromAssets: true,
          ),
          equals(TfliteStyleTransferMock.mockGeneratedPath),
        );
      });
    });
  });
}
