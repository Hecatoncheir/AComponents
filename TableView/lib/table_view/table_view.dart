library table_view;

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:table_view/entities.dart';

//List<Map<String, dynamic>> columns = <Map<String, dynamic>>[
//{"id": 0, "name": "Row Id", "field": "id", "sortable": true, "sort": "asc", "hidden": false},
//{"id": 01, "name": "First column", "field": "firstColumn", "type":"String", "filterable":true, "filter":'some text'},
//{"id": 02, "name": "Second column", "field": "secondColumn"},
//{"id": 03, "name": "Third column", "field": "thirdColumn"}
//];
//
//List<Map<String, dynamic>> rows = <Map<String, dynamic>>[
//  {
//    "id": 01,
//    "firstColumn": "First column value",
//    "secondColumn": "Second column value",
//    "thirdColumn": "Third column value"
//  },
//  {
//    "id": 02,
//    "firstColumn": "First column value",
//    "secondColumn": "Second column value",
//    "thirdColumn": "Third column value"
//  },
//];
@Component(
    selector: 'table-view',
    templateUrl: 'table_view.html',
    directives: const [
      NgFor,
      NgIf,
      NgSwitch,
      NgSwitchWhen,
      NgSwitchDefault,
      MaterialInputComponent,
      MaterialButtonComponent,
      MaterialIconComponent
    ],
    providers: const [
      materialProviders
    ],
    inputs: const <String>[
      'columns',
      'rows'
    ])
class TableView {
  final List<Column> _columns = new List<Column>();

  List<Column> get columns => _columns;

  @Input('columns')
  void set columns(List<Map<String, dynamic>> columnsList) {
    for (Map<String, dynamic> column in columnsList) {
      _columns.add(new Column(
          id: column['id'],
          name: column['name'],
          field: column['field'],
          sort: column['sort'],
          type: column['type'],
          filter: column['filter'],
          filterable: column['filterable'],
          sortable: column['sortable'],
          hidden: column['hidden']));
    }
  }

  Map<String, dynamic> columnTrack(int index, dynamic item) {
    return columns[index];
  }

  List<Row> _rows = new List<Row>();

  List<Row> get rows => _rows;

  /// All operations is mutable
  @Input('rows')
  void set rows(List<Map<String, dynamic>> rowsList) {
    for (Map<String, dynamic> row in rowsList) {
      Row _row = new Row(id: row['id'], hidden: row['_hidden']);

      for (String key in row.keys) {
        _row[key] = row[key];
      }

      _rows.add(_row);
    }

    updateRows(columns, _rows).then((List<Row> updatedRows) {
      _rows = updatedRows;
    });
  }

  Row rowTrack(int index, dynamic item) {
    return rows[index];
  }

  /// Call when enter was pressed on column filter input
  Future<Null> filterForFieldChanged(
      KeyboardEvent event, Map<String, dynamic> column) async {
    InputElement input = event.target;
    int indexOfFilterUpdatedColumn = columns.indexOf(column);
    columns[indexOfFilterUpdatedColumn]['filter'] = input.value;

    updateRows(columns, _rows).then((List<Row> updatedRows) {
      _rows = updatedRows;
    });
  }

  /// Parsing 'filter' field of columns for make structure like:
  /// [{'fieldName':'id', 'filterValue': 'some text', 'type': int}, {'fieldName':'name', 'filterValue': 'some text'}]
  List<Map<String, String>> getFieldsForFiltering(List<Column> columns) {
    List<Map<String, dynamic>> filterFields = new List<Map<String, dynamic>>();

    for (Map<String, dynamic> column in columns) {
      if (column['filterable'] != null && column['filterable'] == true) {
        if (column['filter'] == null && column['filter'].toString().isEmpty)
          continue;

        filterFields.add(<String, dynamic>{
          'fieldName': column['field'],
          'filterValue': column['filter'],
          'type': column['type'] == null ? 'String' : column['type']
        });
      }
    }

    return filterFields;
  }

  /// Method for sorting rows by 'sort' property for field in column
  Future<List<Row>> filteringRows(
      List<Row> rows, List<Map<String, dynamic>> fieldsForFiltering) async {
    for (Row row in rows) {
      List<bool> filteringRowsFieldsResult = new List<bool>();

      for (Map<String, dynamic> filteredField in fieldsForFiltering) {
        row['_hidden'] = false;
        dynamic filteredValue = filteredField['filterValue'];

        switch (filteredField['type']) {
          case 'String':
            if (!row[filteredField['fieldName']]
                .toString()
                .toLowerCase()
                .contains(filteredValue.toString().toLowerCase())) {
              filteringRowsFieldsResult.add(false);
            }
            break;

          case 'int':
            if (filteredValue != null) {
              if (filteredValue.runtimeType != int &&
                  filteredValue.toString().isEmpty) break;

              if (row[filteredField['fieldName']].runtimeType != int) {
                try {
                  row[filteredField['fieldName']] =
                      int.parse(row[filteredField['fieldName']].toString());
                } catch (err) {
                  print(err);
                }
              }

              if (filteredValue.runtimeType != int &&
                  filteredValue.toString().isNotEmpty) {
                try {
                  filteredValue = int.parse(filteredValue.toString());
                } catch (err) {
                  print(err);
                  print('Value must be a number');
                  break;
                }
              }

              if (row[filteredField['fieldName']] != filteredValue)
                filteringRowsFieldsResult.add(false);
            }
            break;
        }
      }

      if (filteringRowsFieldsResult.contains(false)) row['_hidden'] = true;
    }

    return rows;
  }

  /// Parsing 'sort' field of columns for make structure like:
  /// [{'fieldName':'id', 'sortType': 'asc'}, {'fieldName':'name', 'sortType': 'desc'}]
  List<Map<String, String>> getFieldsForSorting(List<Column> columns) {
    List<Map<String, String>> fieldsWithSortingTypes =
        new List<Map<String, String>>();

    for (Map<String, dynamic> column in columns) {
      if (column['sortable'] == false) continue;

      String sortType = column['sort'];
      if (sortType != null && sortType.isNotEmpty) {
        String sortedField = column['field'];

        Map<String, String> fieldAndTypeForSorting = <String, String>{
          'fieldName': sortedField,
          'sortType': sortType
        };

        fieldsWithSortingTypes.add(fieldAndTypeForSorting);
      }
    }

    return fieldsWithSortingTypes;
  }

  /// Method for sorting rows by 'sort' property for field in column
  List<Row> sortRows(
      List<Row> rows, List<Map<String, String>> fieldsForSorting) {
    for (Map<String, String> sortingField in fieldsForSorting) {
      String sortType = sortingField['sortType'];
      String sortedField = sortingField['fieldName'];

      if (sortType == 'asc') {
        rows.sort(
            (Map<String, dynamic> previewRow, Map<String, dynamic> nextRow) {
          int isAsc = previewRow[sortedField]
              .toString()
              .compareTo(nextRow[sortedField].toString());
          return isAsc;
        });
      } else {
        rows.sort(
            (Map<String, dynamic> previewRow, Map<String, dynamic> nextRow) {
          int isDesc = nextRow[sortedField]
              .toString()
              .compareTo(previewRow[sortedField].toString());
          return isDesc;
        });
      }
    }

    return rows;
  }

  Future<Null> changeSortTypeOfColumn(
      int columnIndex, String newSortType) async {
    Column columnOfChangingSort = columns[columnIndex];

    for (Column column in columns) {
      /// Other sorting must be disabled for now
      if (column != columnOfChangingSort && column.sortable == true) {
        column.sort = null;
      }

      if (column == columnOfChangingSort) {
        column.sort = newSortType;
      }
    }

    updateRows(columns, rows).then((List<Row> rows) => _rows = rows);
  }

  Future<List<Row>> updateRows(
      List<Column> columnList, List<Row> rowsList) async {
    List<Row> updatedRows = rowsList;

    /// If columns is not null rows can be sorted
    if (columns != null) {
      List<Map<String, dynamic>> filterFields = getFieldsForFiltering(columns);

      /// Filtering rows first
      if (filterFields.isNotEmpty) {
        List<Row> filteredRows = await filteringRows(updatedRows, filterFields);
        updatedRows = filteredRows;
      }

      List<Map<String, String>> fieldsWithSortingTypes =
          getFieldsForSorting(columns);

      /// Sorting after filtering
      if (fieldsWithSortingTypes.isNotEmpty) {
        List<Row> sortedRows = sortRows(updatedRows, fieldsWithSortingTypes);
        updatedRows = sortedRows;
      }
    }

    return updatedRows;
  }
}
