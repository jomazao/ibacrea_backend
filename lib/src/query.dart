import 'package:ibacrea_backend/ibacrea_backend.dart';

import 'sort.dart';
import 'field.dart';
import 'package:http/http.dart' as http;

class Query<T extends Model> {
  final int limit;
  final int offset;
  final List<String> fields;
  final String searchFields;
  final List<Sort> sorts;
  final List<Field> fieldsQuery;
  final Map headers;
  final String basePath;
  final T Function(Map map) fromMapOfT;

  const Query({
    this.limit,
    this.offset,
    this.fields = const [],
    this.searchFields,
    this.sorts = const [],
    this.fieldsQuery = const [],
    this.headers,
    this.basePath,
    this.fromMapOfT,
  });

  factory Query.copyWith(
    Query query, {
    final int limit,
    final int offset,
    final List<String> fields,
    final String searchFields,
    final List<Sort> sorts,
    final List<Field> fieldsQuery,
    final Map headers,
    final String basePath,
    final T Function(Map map) fromMapOfT,
  }) =>
      Query(
        limit: limit ?? query.limit,
        offset: offset ?? query.offset,
        fields: fields ?? query.fields,
        searchFields: searchFields ?? query.searchFields,
        sorts: sorts ?? query.sorts,
        fieldsQuery: fieldsQuery ?? query.fieldsQuery,
        headers: headers ?? query.headers,
        basePath: basePath ?? query.basePath,
        fromMapOfT: fromMapOfT ?? query.fromMapOfT,
      );

  Future<QueryResponse> get() async {
    final url = urlQuery();
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return QueryResponse(response, fromMapOfT);
    }
    return null;
  }

  String urlQuery() {
    var url = '$basePath?';
    if (limit != null) {
      url += '&limit=$limit';
    }
    if (offset != null) {
      url += '&offset=$offset';
    }
    if ((fields?.isNotEmpty ?? false)) {
      url += '&fields=';
      fields.forEach((field) => url += '$field,');
    }
    if (searchFields != null) {
      url += 'search.fields=$searchFields';
    }
    if ((sorts?.isNotEmpty ?? false)) {
      url += '&sort=';
      sorts.forEach((sort) {
        url += '${sort.field}.';
        url += '${sort.sortType == SortType.asc ? 'asc' : 'desc'}.';
      });
    }

    fieldsQuery?.forEach((field) {
      url += '&${field.field}';

      url += field.queryType != QueryType.eq ? '.' : '';

      switch (field.queryType) {
        case QueryType.eq:
          url += 'eq';
          break;
        case QueryType.gt:
          url += 'gt';
          break;
        case QueryType.ge:
          url += 'ge';
          break;
        case QueryType.lt:
          url += 'lt';
          break;
        case QueryType.ne:
          url += 'ne';
          break;
        case QueryType.sw:
          url += 'sw';
          break;
        case QueryType.ew:
          url += 'ew';
          break;
        case QueryType.has:
          url += 'has';
          break;

        case QueryType.notHas:
          url += '!has';
          break;
        case QueryType.notSw:
          url += '!sw';
          break;
        case QueryType.notEw:
          url += '!ew';
          break;
      }
      url += '=';
      url += field.value;
    });

    return url;
  }
}
