// Copyright (c) 2022, Luis Ciber
// https://luisciber.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';

import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // group('E2E', () {
  //   testWidgets('getPlatformName', (tester) async {
  //     app.main();
  //     await tester.pumpAndSettle();
  //     await tester.tap(find.text('Get Platform Name'));
  //     await tester.pumpAndSettle();
  //     final expected = expectedPlatformName();
  //     await tester.ensureVisible(find.text('Platform Name: $expected'));
  //   });
  // });
}

String expectedPlatformName() {
  if (Platform.isAndroid) return 'Android';
  if (Platform.isIOS) return 'iOS';
  throw UnsupportedError('Unsupported platform ${Platform.operatingSystem}');
}
