import 'package:dartz/dartz.dart';
import 'package:flutter_pagination/data/model/product.dart';
import '../../../core/handle_error/failure.dart';

abstract class BaseRepo {
  Future<Either<Failure, List<Product>>> getData({
    required int pageNumber,
    required int numberOfProductsPerRequest,
  });
}