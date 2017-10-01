@Tags(const ['aot'])
@TestOn('browser')
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_test/angular_test.dart';
import 'package:pageloader/objects.dart';
import 'package:test/test.dart';

import 'package:table_view/table_view/table_view.dart';

const List<Map<String, dynamic>> columns = const <Map<String, dynamic>>[
  const {
    "id": 0,
    "name": "Row Id",
    "field": "id",
    "sortable": true,
    "sort": "asc",
    "hidden": false
  },
  const {
    "id": 01,
    "name": "First column",
    "field": "firstColumn",
    "sortable": true,
    "filtered": true,
    "filter": null,
  },
  const {
    "id": 02,
    "name": "Second column",
    "field": "secondColumn",
  },
  const {"id": 03, "name": "Third column", "field": "thirdColumn"}
];

const List<Map<String, dynamic>> rows = const <Map<String, dynamic>>[
  const {
    "id": 01,
    "firstColumn": "A First column value example",
    "secondColumn": "Second column value",
    "thirdColumn": "Third column value"
  },
  const {
    "id": 02,
    "firstColumn": "B First column value",
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
  });

  tearDown(() async {
    fixture.update((TableView tableView) {
      tableView..columns.clear()..rows.clear();
    });

    testedTableView = await fixture.resolvePageObject(TestedTableView);
  });

  group('TableView component', () {
    test('can render a table', () async {
      fixture.update((TableView tableView) {
        tableView
          ..columns = columns
          ..rows = rows;
      });

      testedTableView = await fixture.resolvePageObject(TestedTableView);

      expect(await testedTableView.table, isNotEmpty);
      expect(await testedTableView.firstColumn, equals('Row Id'));
      expect(await testedTableView.firstRow, equals('1'));
    });
  });

  group('Column', () {
    test('can be hidden', () async {
      fixture.update((TableView tableView) {
        tableView.columns.first.hidden = true;
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
      fixture.update((TableView tableView) {
        tableView.columns.first.sort = 'asc';
        tableView.rows = rows;
      });

      testedTableView = await fixture.resolvePageObject(TestedTableView);
      expect(await testedTableView.firstRow, equals('1'));
    });

    test('can be descending sorted', () async {
      fixture.update((TableView tableView) {
        tableView.columns.first.sort = 'desc';
        tableView.rows = rows;
      });

      testedTableView = await fixture.resolvePageObject(TestedTableView);

      expect(await testedTableView.firstRow, equals('2'));
    });
  });

  group('Rows', () {
    test('can be filtered', () async {
      fixture.update((TableView tableView) {
        List<Map<String, dynamic>> updatedColumns = new List.from(tableView.columns);
        updatedColumns[0]['sortable'] = false;
        updatedColumns[0]['hidden'] = true;
        updatedColumns[1]['filterable'] = true;
        updatedColumns[1]['filter'] = 'b first';

        tableView.columns = updatedColumns;
      });

      testedTableView = await fixture.resolvePageObject(TestedTableView);
      expect(await testedTableView.firstRow, equals('B First column value'));

      fixture.update((TableView tableView) {
        tableView.columns[1].filter = 'example';
        tableView.rows = rows;
      });

      testedTableView = await fixture.resolvePageObject(TestedTableView);
      expect(await testedTableView.firstRow,
          equals('A First column value example'));
    });
  });
}
