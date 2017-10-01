library table_view_entities;

import 'dart:collection';

class Column extends MapBase<String, dynamic> {
  final Map _entityMap = new Map<String, dynamic>();

  void set id(dynamic value) => _entityMap['id'] = value;
  dynamic get id => _entityMap['id'];

  void set name(String value) => _entityMap['name'] = value;
  String get name => _entityMap['name'];

  void set field(String value) => _entityMap['field'] = value;
  String get field => _entityMap['field'];

  void set sort(String value) => _entityMap['sort'] = value;
  String get sort => _entityMap['sort'];

  void set type(String value) => _entityMap['type'] = value;
  String get type => _entityMap['type'];

  void set filter(dynamic value) => _entityMap['filter'] = value;
  dynamic get filter => _entityMap['filter'];

  void set filterable(bool value) => _entityMap['filterable'] = value;
  bool get filterable => _entityMap['filterable'];

  void set sortable(bool value) => _entityMap['sortable'] = value;
  bool get sortable => _entityMap['sortable'];

  void set hidden(bool value) => _entityMap['hidden'] = value;
  bool get hidden => _entityMap['hidden'];

  Column(
      {dynamic id,
      String name,
      String field,
      String sort,
      String type,
      dynamic filter,
      bool filterable,
      bool sortable,
      bool hidden}) {
    this
      ..id = id
      ..name = name
      ..field = field
      ..sort = sort
      ..type = type
      ..filter = filter
      ..filterable = filterable
      ..sortable = sortable
      ..hidden = hidden;
  }

  operator [](Object key) {
    return _entityMap[key];
  }

  operator []=(String key, dynamic value) {
    _entityMap[key] = value;
  }

  get keys => _entityMap.keys;

  remove(key) {
    _entityMap.remove(key);
  }

  clear() {
    _entityMap.clear();
  }
}

class Rows<Row> extends ListBase<Row> {
  final List _entitiesList = new List<Map<String, dynamic>>();

  operator [](int position) {
    return _entitiesList[position];
  }

  operator []=(int position, Row value) {
    _entitiesList[position] = value;
  }

  int get length => _entitiesList.length;
  void set length(int newLength) => _entitiesList.length = newLength;

  bool equals(List<Map<String,dynamic>> rowsList) {
    return false;
  }
}

class Row extends MapBase<String, dynamic> {
  final Map _entityMap = new Map<String, dynamic>();

  void set id(dynamic value) => _entityMap['id'] = value;
  dynamic get id => _entityMap['id'];

  void set hidden(bool value) => _entityMap['_hidden'] = value;
  bool get hidden => _entityMap['_hidden'];

  Row({dynamic id, bool hidden}) {
    this
      ..id = id
      ..hidden = hidden;
  }

  operator [](Object key) {
    return _entityMap[key];
  }

  operator []=(String key, dynamic value) {
    _entityMap[key] = value;
  }

  get keys => _entityMap.keys;

  remove(key) {
    _entityMap.remove(key);
  }

  clear() {
    _entityMap.clear();
  }
}
