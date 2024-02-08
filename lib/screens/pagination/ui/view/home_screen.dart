import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../data/model/product.dart';
import '../../../cart_screen/cart_screen.dart';
import '../../../wishlist_screen/wishlist_screen.dart';
import '../../pagination_bloc.dart';
import '../widgets/error_dialog.dart';
import '../widgets/product_card.dart';

const List<Color> _kDefaultRainbowColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PaginationBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<PaginationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        shadowColor: Colors.black,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pagination with Bloc ',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w500, color: Colors.teal.shade900),
            ),
          ],
        ),
        actions: [
          BlocBuilder<PaginationBloc, PaginationState>(
            builder: (context, state) {
              return Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, WishListScreen.routeName);
                    },
                    icon: Icon(
                      bloc.wishListedProducts.isEmpty
                          ? Icons.favorite_border
                          : Icons.favorite,
                      color: Colors.redAccent,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  bloc.wishListedProducts.isNotEmpty
                      ? Text(
                          bloc.wishListedProducts.length.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.redAccent),
                        )
                      : SizedBox(),
                ],
              );
            },
          ),
          BlocBuilder<PaginationBloc, PaginationState>(
            builder: (context, state) {
              return Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, CartScreen.routeName);
                    },
                    icon: Icon(
                      bloc.inCartProducts.isEmpty
                          ? Icons.shopping_cart_outlined
                          : Icons.shopping_cart,
                      color: Colors.deepPurple,
                    ),
                  ),
                  bloc.inCartProducts.isNotEmpty
                      ? Text(
                          bloc.inCartProducts.length.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.deepPurple),
                        )
                      : SizedBox(),
                ],
              );
            },
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          bloc.add(refreshBlocAndReload());
        },
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          child: BlocConsumer(
            bloc: context.read<PaginationBloc>(),
            builder: (context, state) {
              if (state is PaginationErrorState) {
                return errorDialog(
                  size: 20,
                  onPressed: () {
                    bloc.add(refreshBlocAndReload());
                  },
                );
              } else {
                List<Product> products = bloc.products;
                List<Product> cartItems = bloc.inCartProducts;
                List<Product> wishListItems = bloc.wishListedProducts;
                if (bloc.products.isEmpty) {
                  return Center(
                    child: getLoadingIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: products.length + 1,
                  itemBuilder: (context, index) {
                    if (!(state is PaginationLoadingState) &&
                        index == bloc.products.length - bloc.nextPageTrigger) {
                      bloc.add(CheckIfNeedMoreDataEvent(index: index));
                    }
                    if (index == products.length) {
                      return state is PaginationLoadingState
                          ? Center(
                              child: getLoadingIndicator(),
                            )
                          : SizedBox();
                    }
                    return ProductCard(
                        inCart: cartItems.contains(products[index]),
                        inWishList: wishListItems.contains(products[index]),
                        product: products[index]);
                  },
                );
              }
            },
            listener: (context, state) {},
          ),
        ),
      ),
    );
  }

  Widget getLoadingIndicator() {
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: w / 4,
      width: w / 4,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: LoadingIndicator(
            indicatorType: Indicator.ballSpinFadeLoader,
            strokeWidth: 2,
            colors: _kDefaultRainbowColors,
            backgroundColor: Colors.transparent,
            pathBackgroundColor: Colors.transparent),
      ),
    );
  }
}
