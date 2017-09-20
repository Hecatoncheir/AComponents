import 'package:angular/angular.dart';
import 'package:table_view/components.dart';

@Component(
    selector: 'table-view-simple-example',
    template: """
       <table-view></table-view>
    """,
    directives: const [TableView])
class TableViewSimpleExample {
  List<Map<String, dynamic>> columns = <Map<String, dynamic>>[
    {"id": 0}
  ];
}


void main(){
  bootstrap(TableViewSimpleExample);
}