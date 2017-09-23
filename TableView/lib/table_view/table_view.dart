library table_view;

import 'package:angular/angular.dart';

@Component(
    selector: 'table-view',
    templateUrl: 'table_view.html',
    directives: const [NgFor, NgIf],
    inputs: const <String>['columns', 'rows'])
class TableView {
  @Input()
  List<Map<String, dynamic>> columns;

  Map<String, dynamic> columnTrack(int index, dynamic item) {
    return columns[index];
  }

  List<Map<String, dynamic>> _rows;
  List<Map<String, dynamic>> get rows => _rows;

  @Input('rows')
  void set rows(List<Map<String, dynamic>> rowsList) {
    _rows = rowsList;
  }
}
