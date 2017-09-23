import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:table_view/components.dart';

@Component(
    selector: 'table-view-simple-example',
    template: """
      <material-checkbox
          [(checked)]="columns.first['hidden']"
          label="Hide first column">
      </material-checkbox>
      
      <table-view [columns]='columns' [rows]='rows'></table-view>
    """,
    directives: const [TableView, materialDirectives],
    providers: const [materialProviders])
class TableViewSimpleExample {
  List<Map<String, dynamic>> columns = <Map<String, dynamic>>[
    {"id": 0, "name": "Row Id", "field": "id", "sort": "asc", "hidden": true},
    {"id": 01, "name": "First column", "field": "firstColumn"},
    {"id": 02, "name": "Second column", "field": "secondColumn"},
    {"id": 03, "name": "Third column", "field": "thridColumn"}
  ];

  List<Map<String, dynamic>> rows = <Map<String, dynamic>>[
    {
      "id": 01,
      "firstColumn": "First column value",
      "secondColumn": "Second column value",
      "thridColumn": "Thrid column value"
    },
    {
      "id": 02,
      "firstColumn": "First column value",
      "secondColumn": "Second column value",
      "thridColumn": "Thrid column value"
    },
  ];
}

void main() {
  bootstrap(TableViewSimpleExample);
}
