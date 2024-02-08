part of 'pagination_bloc.dart';

abstract class PaginationState {}

class PaginationInitialState extends PaginationState {
  PaginationInitialState();
}

class PaginationLoadedState extends PaginationState {}

class PaginationLoadingState extends PaginationState {}

class PaginationErrorState extends PaginationState {}

class PaginationCartUpdatedState extends PaginationState {}

class PaginationWishListUpdatedState extends PaginationState {}
