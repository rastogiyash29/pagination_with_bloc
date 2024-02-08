import 'package:dartz/dartz.dart';
import 'package:flutter_pagination/data/model/product.dart';
import '../../../core/handle_error/failure.dart';
import '../../data/repository/base_repo.dart';

class GetDataUseCase {
  final BaseRepo baseRepo;

  GetDataUseCase({required this.baseRepo});

  Future<Either<Failure, List<Product>>> call({
    required int pageNumber,
    required int numberOfPostsPerRequest,
  }) async {
    return await baseRepo.getData(
      numberOfProductsPerRequest: numberOfPostsPerRequest,
      pageNumber: pageNumber,
    );
  }
}