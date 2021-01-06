import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ibacrea_backend/src/exception.dart';
import 'package:ibacrea_backend/src/session.dart';
import 'model.dart';
import 'query.dart';
import 'query_response.dart';

abstract class Repository<T extends Model> {
  final String baseUrl;
  final String path;
  final T Function(Map map) fromMapOfT;
  final Session session;

  Repository(
    this.baseUrl,
    this.path,
    this.fromMapOfT,
    this.session,
  );
  String get basePath => '$baseUrl$path';

  Map<String, dynamic> get defaultHeaders => {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${session.bearerToken}'
      };

  Future<int> create(T model) async {
    final url = '$basePath';
    final body = jsonEncode(model.toMap());
    final response = await http.post(url, headers: defaultHeaders, body: body);

    final bodyResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return bodyResponse['id'];
    } else {}
    throw (BackendException('Backend Error', response.statusCode, url));
  }

  Future<T> update({T model, Map<String, dynamic> data}) async {
    assert(model != null || data != null);
    final url = '$basePath/${model.id}';
    final body = data ?? jsonEncode(model.toMap());
    final response = await http.patch(url, headers: defaultHeaders, body: body);
    final bodyResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return fromMapOfT((jsonDecode(response.body)));
    }
    throw (BackendException('Backend Error', response.statusCode, url));
  }

  Future<bool> delete(int id) async {
    var url = '$basePath/$id';
    var response = await http.delete(url, headers: defaultHeaders);
    final bodyResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return true;
    }
    throw (BackendException('Backend Error', response.statusCode, url));
  }

  Future<T> get(int id) async {
    var url = '$basePath/$id';
    var response = await http.get(url, headers: defaultHeaders);
    if (response.statusCode == 200) {
      return fromMapOfT(jsonDecode(response.body));
    }
    throw (BackendException('Backend Error', response.statusCode, url));
  }

  Future<QueryResponse<T>> getAll({Query query}) async {
    Query.copyWith(
      query,
      basePath: basePath,
      fromMapOfT: fromMapOfT,
      headers: defaultHeaders,
    );
  }
}
