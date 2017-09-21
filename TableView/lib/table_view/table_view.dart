library table_view;

import 'package:angular/angular.dart';

@Component(
    selector: 'table-view',
    templateUrl: 'table_view.html',
    directives: const [NgFor],
    inputs: const <String>['columns', 'rows'])
class TableView {
  @Input()
  List<Map<String, dynamic>> columns;

  @Input()
  List<Map<String, dynamic>> rows;
}
