import 'dart:convert';
import 'package:flutter_pagination/data/model/product.dart';
import 'package:http/http.dart';

abstract class RemoteData {
  Future<List<Product>> getData({
    required int pageNumber,
    required int numberOfProductsPerRequest,
  });
}

class RemoteDataImpl extends RemoteData {
  @override
  Future<List<Product>> getData({
    required int pageNumber,
    required int numberOfProductsPerRequest,
  }) async {
    final response = await get(Uri.parse(
      "https://dummyjson.com/products?limit=$numberOfProductsPerRequest&skip=${pageNumber*numberOfProductsPerRequest}"));

    try {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        List<Product> productList = (jsonResponse['products'] as List)
            .map((i) => Product.fromJson(i))
            .toList();
        return productList;
      } else {
        print(response.statusCode);
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
