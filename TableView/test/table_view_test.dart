@Tags(const ['aot'])
@TestOn('browser')
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_test/angular_test.dart';
import 'package:pageloader/objects.dart';
import 'package:test/test.dart';

import 'package:table_view/table_view/table_view.dart';

List<Map<String, dynamic>> columns = <Map<String, dynamic>>[
  {
    "id": 0,
    "name": "Row Id",
    "field": "id",
    "sortable": true,
    "sort": "asc",
    "hidden": false
  },
  {"id": 01, "name": "First column", "field": "firstColumn"},
  {"id": 02, "name": "Second column", "field": "secondColumn"},
  {"id": 03, "name": "Third column", "field": "thirdColumn"}
];

List<Map<String, dynamic>> rows = <Map<String, dynamic>>[
  {
    "id": 01,
    "firstColumn": "First column value",
    "secondColumn": "Second column value",
    "thirdColumn": "Third column value"
  },
  {
    "id": 02,
    "firstColumn": "First column value",
    "secondColumn": "Second column value",
    "thirdColumn": "Third column value"
  },
];

class TestedTableView {
  @ByTagName('table')
  PageLoaderElement _table;
  Future<String> get table => _table.visibleText;

  Stream<PageLoaderElement> _firstColumn() =>
      _table.getElementsByCss('table thead th:first-child span');
  Future<String> get firstColumn =>
      _firstColumn().first.then((PageLoaderElement firstColumnInTable) {
        return firstColumnInTable.visibleText;
      });

  Stream<PageLoaderElement> _firstRow() =>
      _table.getElementsByCss('table tbody tr:first-child');
  Future<String> get firstRow =>
      _firstRow().first.then((PageLoaderElement firstRowInTable) {
        return firstRowInTable
            .getElementsByCss('td:first-child')
            .first
            .then((PageLoaderElement firstColumnInFirstTable) {
          return firstColumnInFirstTable.visibleText;
        });
      });
}

@AngularEntrypoint()
void main() {
  final testBed = new NgTestBed<TableView>();
  NgTestFixture<TableView> fixture;
  TestedTableView testedTableView;

  setUpAll(() async {
    fixture = await testBed.create();
  });

  tearDownAll(disposeAnyRunningTest);

  setUp(() async {
    fixture.update((TableView tableView) {
      tableView
        ..columns = columns
        ..rows = rows;
    });

    testedTableView = await fixture.resolvePageObject(TestedTableView);
  });

  tearDown(() async {
    fixture.update((TableView tableView) {
      tableView
        ..columns = null
        ..rows = null;
    });

    testedTableView = await fixture.resolvePageObject(TestedTableView);
  });

  group('TableView component', () {
    test('can render a table', () async {
      expect(await testedTableView.table, isNotEmpty);
      expect(await testedTableView.firstColumn, equals('Row Id'));
      expect(await testedTableView.firstRow, equals('1'));
    });
  });

  group('Column', () {
    test('can be hidden', () async {
      List<Map<String, dynamic>> updatedWithHiddenColumn =
          new List.from(columns);
      updatedWithHiddenColumn.first['hidden'] = true;

      fixture.update((TableView tableView) {
        tableView
          ..columns = updatedWithHiddenColumn
          ..rows = rows;
      });

      testedTableView = await fixture.resolvePageObject(TestedTableView);

      expect(await testedTableView.firstColumn, equals('First column'));

      fixture.update((TableView tableView) {
        tableView.columns.first['hidden'] = false;
      });

      testedTableView = await fixture.resolvePageObject(TestedTableView);

      expect(await testedTableView.firstColumn, equals('Row Id'));
    });

    test('can be ascending sorted', () async {
      List<Map<String, dynamic>> withAscendingSortedColumn =
          new List.from(columns);
      withAscendingSortedColumn.first['sort'] = 'asc';

      fixture.update((TableView tableView) {
        tableView
          ..columns = withAscendingSortedColumn
          ..rows = rows;
      });

      testedTableView = await fixture.resolvePageObject(TestedTableView);
      expect(await testedTableView.firstRow, equals('1'));
    });

    test('can be descending sorted', () async {
      List<Map<String, dynamic>> updatedWithDescendingSortedColumn =
          new List.from(columns);
      updatedWithDescendingSortedColumn.first['sort'] = 'desc';

      fixture.update((TableView tableView) {
        tableView
          ..columns = updatedWithDescendingSortedColumn
          ..rows = rows;
      });

      testedTableView = await fixture.resolvePageObject(TestedTableView);

      expect(await testedTableView.firstRow, equals('2'));
    });
  });
}
