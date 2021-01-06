import 'package:http/http.dart';
import 'package:ibacrea_backend/src/query.dart';
import 'model.dart';
import 'links.dart';
import 'dart:convert';

class QueryResponse<T extends Model> {
  int pages;
  int pageSize;
  int actualPage;
  int total;
  Links links;
  List<T> data;
  Query query;

  bool get hasMore => actualPage == pages;

  QueryResponse(
    Response response,
    T Function(Map) builder, {
    this.query,
  }) {
    final Map body = json.decode(response.body);
    pages = body['pages'];
    pageSize = body['pageSize'];
    actualPage = body['actualPage'];
    total = body['total'];
    links = Links.fromMap(body['links']);
    data = (body['data'] as List<Map<String, dynamic>>)
        .map<T>((map) => builder(map))
        .toList();
  }

  Future<QueryResponse> next() {
    return Query.copyWith(query, offset: actualPage + 1).get();
  }

  Future<QueryResponse> after() {
    return Query.copyWith(query, offset: actualPage - 1).get();
  }

  Future<QueryResponse> first() {
    return Query.copyWith(query, offset: 1).get();
  }

  Future<QueryResponse> last() {
    return Query.copyWith(query, offset: pages).get();
  }
}
