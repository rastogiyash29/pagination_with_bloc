import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagination/utils/pagination_configuration.dart';

import '../../core/handle_error/failure.dart';
import '../../data/model/product.dart';
import '../../domain/usecase/get_data_use_case.dart';
part 'pagination_event.dart';

part 'pagination_state.dart';

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  List<Product> wishListedProducts = [];
  List<Product> inCartProducts = [];

  final GetDataUseCase getDataUseCase;
  final pagesAdded = <int>{};
  bool isLastPage = false;
  int pageNumber = 0;
  final int numberOfPostsPerRequest =
      PaginationConfiguration.numberOfProductsPerPage;
  List<Product> products = [];
  final int nextPageTrigger = PaginationConfiguration.nextPageTrigger;

  PaginationBloc(this.getDataUseCase) : super(PaginationInitialState()) {
    on<LoadPageEvent>((event, emit) async {
      emit(PaginationLoadingState());
      try {
        final Either<Failure, List<Product>> result = await getDataUseCase(
          numberOfPostsPerRequest: numberOfPostsPerRequest,
          pageNumber: pageNumber,
        );
        result.fold(
          (l) {
            print("error --> ${l.failure}");
            emit(PaginationErrorState());
          },
          (postList) {
            if (pagesAdded.contains(pageNumber))
              return;
            else
              pagesAdded.add(pageNumber);
            print("fetched "+postList.length.toString());
            isLastPage = postList.length < numberOfPostsPerRequest;
            pageNumber = pageNumber + 1;
            products.addAll(postList);
            emit(PaginationLoadedState());
          },
        );
      } catch (e) {
        print("error --> $e");
        emit(PaginationErrorState());
      }
    });

    on<CheckIfNeedMoreDataEvent>((event, emit) async {
      print('called load More data');
      if(isLastPage)return;
      emit(PaginationLoadingState());
      if (event.index == products.length - nextPageTrigger && !isLastPage) {
        add(const LoadPageEvent());
      }
    });

    on<refreshBlocAndReload>((event, emit) async {
      isLastPage = false;
      pageNumber = 0;
      products.clear();
      wishListedProducts.clear();
      inCartProducts.clear();
      pagesAdded.clear();
      add(const LoadPageEvent());
    });

    on<ToggleProductInCartEvent>((event, emit) async {
      if (inCartProducts.contains(event.product)) {
        inCartProducts.remove(event.product);
      } else {
        inCartProducts.add(event.product);
      }
      emit(PaginationCartUpdatedState());
    });

    on<ToggleProductInWishListEvent>((event, emit) async {
      if (wishListedProducts.contains(event.product)) {
        wishListedProducts.remove(event.product);
      } else {
        wishListedProducts.add(event.product);
      }
      emit(PaginationWishListUpdatedState());
    });
  }
}
