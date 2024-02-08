part of 'pagination_bloc.dart';

abstract class PaginationEvent extends Equatable {
  const PaginationEvent();

  @override
  List<Object?> get props => [];
}

class LoadPageEvent extends PaginationEvent {
  const LoadPageEvent();
}

class CheckIfNeedMoreDataEvent extends PaginationEvent {
  final int index;
  const CheckIfNeedMoreDataEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class refreshBlocAndReload extends PaginationEvent{}

final class ToggleProductInWishListEvent extends PaginationEvent {
  final Product product;

  ToggleProductInWishListEvent({required this.product});
}

final class ToggleProductInCartEvent extends PaginationEvent {
  final Product product;

  ToggleProductInCartEvent({required this.product});
}
