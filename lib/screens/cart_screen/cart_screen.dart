import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/product.dart';
import '../pagination/pagination_bloc.dart';
import '../pagination/ui/view/home_screen.dart';
import '../pagination/ui/widgets/product_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static const routeName = '/cart_screen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late PaginationBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<PaginationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
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
              'Cart',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.deepPurple.shade900),
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
            if (bloc.inCartProducts.length > 0) {
              List<Product> products = bloc.products;
              List<Product> cartItems = bloc.inCartProducts;
              List<Product> wishListItems = bloc.wishListedProducts;
              int total=0;
              for(var item in cartItems)total+=item.price;
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(10.0),
                    width: double.maxFinite,
                    // height: h / 3,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade400,
                              offset: Offset(1, 2),
                              blurRadius: 2)
                        ]),
                    child: Row(
                      children: [
                        Text(
                          'Cart Total: ',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500,color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        Expanded(
                          child: Text(
                            '₹ ${total} ',
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold,color: Colors.indigo),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                            inCart: cartItems.contains(cartItems[index]),
                            inWishList:
                                wishListItems.contains(cartItems[index]),
                            product: cartItems[index]);
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: w / 2,
                      height: w / 2,
                      child: Image.asset('assets/images/cart_screen_icon.png')),
                  SizedBox(
                    height: 40.0,
                  ),
                  SizedBox(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                          backgroundColor: Colors.cyanAccent.shade100,
                          shadowColor: Colors.black,
                          elevation: 2.0 // This is the new background color
                          ),
                      label: Text(
                        'Cart is Empty,\nShop Now!',
                        style:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(),
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
