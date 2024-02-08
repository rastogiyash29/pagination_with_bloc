import 'package:dartz/dartz.dart';
import 'package:flutter_pagination/data/model/product.dart';

import '../../core/handle_error/failure.dart';
import '../../data/data_source/remote_data_source.dart';
import 'base_repo.dart';

class Repo extends BaseRepo {
  final RemoteData remoteData;

  Repo({required this.remoteData});

  @override
  Future<Either<Failure, List<Product>>> getData({
    required int pageNumber,
    required int numberOfProductsPerRequest,
  }) async {
    if (await checkInternetConnection()) {
      try {
        final result = await remoteData.getData(
          numberOfProductsPerRequest: numberOfProductsPerRequest,
          pageNumber: pageNumber,
        );
        return Right(result);
      }catch(e) {
        return left(Failure(failure:e.toString()));
      }
    } else {
      return left( Failure(failure: 'No Internet Connection'));
    }
  }

  Future<bool> checkInternetConnection() async {
    // return await InternetConnection().hasInternetAccess;
    return true;
  }
}
