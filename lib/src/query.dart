import 'sort.dart';
import 'field.dart';

class Query {
  int limit;
  int offset;
  List<String> fields;
  String searchFields;
  List<Sort> sorts;
  List<Field> fieldsQuery;

  Query({
    this.limit,
    this.offset,
    this.fields,
    this.searchFields,
    this.sorts,
    this.fieldsQuery,
  }) {
    this.fields = fields ?? [];
    this.sorts = sorts ?? [];
    this.fieldsQuery = fieldsQuery ?? [];
  }
}
