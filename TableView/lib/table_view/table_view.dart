library table_view;

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

//List<Map<String, dynamic>> columns = <Map<String, dynamic>>[
//{"id": 0, "name": "Row Id", "field": "id", "sortable": true, "sort": "asc", "hidden": false},
//{"id": 01, "name": "First column", "field": "firstColumn"},
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
  List<Map<String, String>> filterFields = new List<Map<String, String>>();

  List<Map<String, dynamic>> _columns;
  List<Map<String, dynamic>> get columns => _columns;

  @Input('columns')
  void set columns(List<Map<String, dynamic>> columnsList) {
    _columns = columnsList;
  }

  Map<String, dynamic> columnTrack(int index, dynamic item) {
    return columns[index];
  }

  List<Map<String, dynamic>> _rows;
  List<Map<String, dynamic>> get rows => _rows;

  /// Parsing 'sort' field of columns for make structure like:
  /// [{'fieldName':'id', 'sortType': 'asc'}, {'fieldName':'name', 'sortType': 'desc'}]
  List<Map<String, String>> getFieldsForSorting(
      List<Map<String, String>> columns) {
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
  List<Map<String, dynamic>> sortRows(List<Map<String, String>> rows,
      List<Map<String, String>> fieldsForSorting) {
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
    Map<String, dynamic> columnOfChangingSort = columns[columnIndex];

    for (Map<String, dynamic> column in columns) {
      /// Other sorting must be disabled for now
      if (column != columnOfChangingSort && column['sortable'] == true) {
        column['sort'] = null;
      }

      if (column == columnOfChangingSort) {
        column['sort'] = newSortType;
      }
    }

    List<Map<String, String>> fieldsWithSortingTypes =
        getFieldsForSorting(columns);

    List<Map<String, dynamic>> sortedRows =
        sortRows(rows, fieldsWithSortingTypes);

    rows = sortedRows;
  }

  /// All operations is mutable
  @Input('rows')
  void set rows(List<Map<String, dynamic>> rowsList) {
    List<Map<String, dynamic>> updatedRows = rowsList;

    /// If columns is not null rows can be sorted
    if (columns != null) {
      List<Map<String, String>> fieldsWithSortingTypes =
          getFieldsForSorting(columns);

      List<Map<String, dynamic>> sortedRows =
          sortRows(rowsList, fieldsWithSortingTypes);
      updatedRows = sortedRows;
    }

    _rows = updatedRows;
  }

  Map<String, dynamic> rowTrack(int index, dynamic item) {
    return rows[index];
  }
}
