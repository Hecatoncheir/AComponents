Do not forget fonts and MDL styles:
```
<!--MDL-->
<link rel="stylesheet" href="https://code.getmdl.io/1.3.0/material.indigo-pink.min.css">
<!--Icon Font-->
<link rel="stylesheet"
      type="text/css"
      href="https://fonts.googleapis.com/icon?family=Material+Icons">
```
    
Use:
```
@Component(
    selector: 'table-view-simple-example',
    template: """
       <table-view [columns]='columns' [rows]='rows'></table-view>
    """,
    directives: const [TableView])
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
```

See simple example.

![preview](https://raw.githubusercontent.com/Rasarts/AComponents/table_view/TableView/preview/table_view_preview.gif)