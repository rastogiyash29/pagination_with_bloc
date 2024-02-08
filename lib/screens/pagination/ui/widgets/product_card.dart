import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

import '../../../../data/model/product.dart';
import '../../pagination_bloc.dart';

class ProductCard extends StatelessWidget {
  final ScreenshotController _screenshotController = ScreenshotController();
  final Product product;
  final bool inCart;
  final bool inWishList;

  ProductCard(
      {required this.inCart,
      required this.inWishList,
      required this.product,
      super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    bool isDarkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Stack(
      children: [
        Screenshot(
          controller: _screenshotController,
          child: Container(
            margin: EdgeInsets.all(10.0),
            width: double.maxFinite,
            // height: h / 3,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade400,
                      offset: Offset(1, 2),
                      blurRadius: 2)
                ]),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: h / 3,
                      color: Colors.grey.shade300,
                      child: Swiper(
                        itemBuilder: (context, index) {
                          final image = product.images[index];
                          return Image.network(
                            image,
                            fit: BoxFit.contain,
                          );
                        },
                        indicatorLayout: PageIndicatorLayout.COLOR,
                        autoplay: product.images.length > 1,
                        itemCount: product.images.length,
                        pagination: const SwiperPagination(),
                        control: product.images.length > 1
                            ? const SwiperControl()
                            : null, // Set control based on the number of items
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: isDarkTheme ? Colors.black : Colors.white,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Brand: ${product.brand}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: isDarkTheme
                                        ? Colors.grey.shade200
                                        : Colors.grey.shade700),
                            maxLines: 2,
                          ),
                          Text(
                            product.title,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                            maxLines: 2,
                          ),
                          RatingBar.builder(
                            initialRating: 3.4,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 25,
                            wrapAlignment: WrapAlignment.start,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            ignoreGestures: true,
                            onRatingUpdate: (double
                                value) {}, // This makes the rating bar read-only
                          ),
                          Text(
                            product.description,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: isDarkTheme
                                        ? Colors.grey.shade200
                                        : Colors.grey.shade700),
                            maxLines: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '₹ ${product.price}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(),
                              ),
                              Text(
                                '(${product.discountPercentage}% off)',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.red.shade100,
                                  shadowColor: Colors.black,
                                  elevation:
                                      2.0 // This is the new background color
                                  ),
                              label: Text(
                                inWishList
                                    ? 'Remove from WishList'
                                    : 'Add To WishList',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(),
                              ),
                              icon: Icon(
                                inWishList
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                context.read<PaginationBloc>().add(
                                    ToggleProductInWishListEvent(
                                        product: product));
                              },
                            ),
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.cyanAccent.shade100,
                                  shadowColor: Colors.black,
                                  elevation:
                                      2.0 // This is the new background color
                                  ),
                              label: Text(
                                inCart ? 'Remove From Cart' : 'Add To Cart',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(),
                              ),
                              icon: Icon(inCart
                                  ? Icons.shopping_cart
                                  : Icons.shopping_cart_outlined),
                              onPressed: () {
                                context.read<PaginationBloc>().add(
                                    ToggleProductInCartEvent(product: product));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () async {
                final imageBytes = await _screenshotController.capture();
                if (imageBytes != null) {
                  String shareText = 'Hey checkout this awesome product!!';

                  io.Directory directory =
                      await getApplicationDocumentsDirectory();
                  String path = directory.path;
                  String fileName =
                      'image_${DateTime.now().millisecondsSinceEpoch}.png';
                  io.File file = io.File(join(path, fileName));
                  await file.writeAsBytes(imageBytes);
                  XFile xfile = XFile(file.path);
                  await Share.shareXFiles([xfile], text: shareText);
                }
              },

              color: Colors.indigo,
              icon: Icon(Icons.ios_share, color: Colors.indigo),
            ),
          ),
        ),
      ],
    );
  }
}
