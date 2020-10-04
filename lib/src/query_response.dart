import 'package:http/http.dart';
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

  QueryResponse(Response response, T Function(Map) builder) {
    var body = json.decode(response.body);
    pages = body['pages'];
    pageSize = body['pageSize'];
    actualPage = body['actualPage'];
    total = body['total'];
    links = Links.fromMap(body['links']);
    data = (body['data'] as List).map<T>((map) => builder(map)).toList();
  }
}
