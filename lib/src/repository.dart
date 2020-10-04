import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'field.dart';
import 'model.dart';
import 'query.dart';
import 'query_response.dart';
import 'sort.dart';

abstract class Repository<T extends Model> {
  final String baseUrl;
  final String path;
  final T Function(Map map) fromMapOfT;

  Repository(
    this.baseUrl,
    this.path,
    this.fromMapOfT,
  );
  String get basePath => '$baseUrl$path';

  final defaultHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  String urlQuery(
    Query query,
  ) {
    var limit = query.limit;
    var offset = query.offset;
    var fields = query.fields;
    var searchFields = query.searchFields;
    var sorts = query.sorts;
    var fieldsQuery = query.fieldsQuery;

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

  Future<int> create(T model) async {
    var url = '$basePath';
    var body = jsonEncode(model.toMap());
    print(url);
    print(body);
    var response = await http.post(url, headers: defaultHeaders, body: body);
    print('que que');
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['id'];
    }
    return null;
  }

  Future<T> update({T model, Map<String, dynamic> data}) async {
    assert(model != null || data != null);
    var url = '$basePath/${model.id}';
    var body = data ?? jsonEncode(model.toMap());
    var response = await http.patch(url, headers: defaultHeaders, body: body);
    if (response.statusCode == 200) {
      return fromMapOfT((jsonDecode(response.body)));
    }
    return null;
  }

  Future<bool> delete(id) async {
    var url = '$basePath/$id';
    var response = await http.delete(url, headers: defaultHeaders);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<T> get(int id) async {
    var url = '$basePath/$id';
    var response = await http.get(url, headers: defaultHeaders);
    if (response.statusCode == 200) {
      return fromMapOfT(jsonDecode(response.body));
    }
    return null;
  }

  Future<QueryResponse<T>> getAll({Query query}) async {
    var url = urlQuery(query ?? Query());
    print(url);
    var response = await http.get(url, headers: defaultHeaders);
    if (response.statusCode == 200) {
      return QueryResponse(response, fromMapOfT);
    }
    return null;
  }
}
