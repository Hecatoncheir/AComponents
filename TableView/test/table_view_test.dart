@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular/angular.dart';
import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';

import 'package:table_view/table_view/table_view.dart';

@AngularEntrypoint()
void main() {
  final testBed = new NgTestBed<TableView>();
  NgTestFixture<TableView> fixture;

  setUp(() async {
    fixture = await testBed.create();
  });

}