import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/product.dart';
import '../pagination/pagination_bloc.dart';
import '../pagination/ui/view/home_screen.dart';
import '../pagination/ui/widgets/product_card.dart';


class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  static const routeName = '/wish_list';

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 5.0,
        shadowColor: Colors.black,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'WishList',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent.shade700),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popUntil(context,
                  (route) => route.settings.name == HomeScreen.routeName);
            },
            icon: Icon(
              Icons.home_filled,
              color: Colors.lightBlueAccent,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: BlocConsumer<PaginationBloc, PaginationState>(
          builder: (context, state) {
            if (bloc.wishListedProducts.length > 0) {
              List<Product> products = bloc.products;
              List<Product> cartItems = bloc.inCartProducts;
              List<Product> wishListItems = bloc.wishListedProducts;
              return ListView.builder(
                itemCount: wishListItems.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                      inCart: cartItems.contains(wishListItems[index]),
                      inWishList: wishListItems.contains(wishListItems[index]),
                      product: wishListItems[index]);
                },
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: w / 2,
                      height: w / 2,
                      child:
                          Image.asset('assets/images/wishlist_icon.png')),
                  SizedBox(height: 40.0,),
                  SizedBox(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30.0,vertical:10.0),
                          backgroundColor: Colors.redAccent.shade200,
                          shadowColor: Colors.black,
                          elevation: 2.0 // This is the new background color
                          ),
                      label: Text(
                        'WishList is Empty,\nShop Now!',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white,fontWeight: FontWeight.w500),
                      ),
                      icon: Icon(
                        Icons.shop,
                        size: 40,
                      ),
                      onPressed: () {
                        Navigator.popUntil(
                            context,
                            (route) =>
                                route.settings.name == HomeScreen.routeName);
                      },
                    ),
                  ),
                ],
              );
            }
          },
          listener: (context, state) {},
        ),
      ),
    );
  }
}
