import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagination/data/data_source/remote_data_source.dart';
import 'package:flutter_pagination/domain/usecase/get_data_use_case.dart';
import 'package:flutter_pagination/screens/cart_screen/cart_screen.dart';
import 'package:flutter_pagination/screens/pagination/pagination_bloc.dart';
import 'package:flutter_pagination/screens/pagination/ui/view/home_screen.dart';
import 'package:flutter_pagination/screens/splash_screen/splash_screen.dart';
import 'package:flutter_pagination/screens/wishlist_screen/wishlist_screen.dart';

import 'data/repository/repo.dart';

void main() {
  runApp(MyApp());
  // runApp(MaterialApp(home: Scaffold(backgroundColor: Colors.tealAccent,),));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<PaginationBloc>(
            create: (context) => PaginationBloc(
              GetDataUseCase(
                  baseRepo: Repo(
                      remoteData:
                          RemoteDataImpl())), // Use your dependency injection mechanism here
            )..add(LoadPageEvent()),
          ),
        ],
        child: MaterialApp(
          initialRoute: SplashScreen.routeName,
          routes: {
            CartScreen.routeName: (context) => CartScreen(),
            WishListScreen.routeName: (context) => WishListScreen(),
            HomeScreen.routeName: (context) => HomeScreen(),
            SplashScreen.routeName: (context) => SplashScreen(),
          },
          title: 'ChatGPT',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(size: 30.0, color: Colors.black),
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 17.0),
            ),
            iconTheme: iconThemeData.copyWith(color: Colors.black),
            iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                  iconColor: MaterialStateProperty.all(Colors.black),
                  shadowColor: MaterialStateProperty.all(Colors.grey)),
            ),
            scaffoldBackgroundColor: Colors.white,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w400),
              bodySmall: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              bodyLarge: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              titleMedium: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w400,
              ),
            ),
            hintColor: Colors.grey,
            inputDecorationTheme: inputDecorationTheme,
            drawerTheme:
                drawerThemeData.copyWith(backgroundColor: Colors.white),
          ),
          darkTheme: ThemeData(
            appBarTheme: appBarTheme,
            iconTheme: iconThemeData,
            iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                  iconColor: MaterialStateProperty.all(Colors.white),
                  shadowColor: MaterialStateProperty.all(Colors.white)),
            ),
            scaffoldBackgroundColor: Colors.black,
            textTheme: textTheme,
            hintColor: Colors.grey,
            inputDecorationTheme: inputDecorationTheme,
            drawerTheme: drawerThemeData,
          ),
          // home: HomeScreen(),
        ));
  }

  TextTheme textTheme = const TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontSize: 28,
      fontWeight: FontWeight.w400,
    ),
  );

  IconThemeData iconThemeData = IconThemeData(color: Colors.white);

  InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
      focusColor: Colors.grey,
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey),
      ),
      hintStyle: TextStyle(color: Colors.grey),
      suffixIconColor: Colors.grey);

  AppBarTheme appBarTheme = const AppBarTheme(
    color: Colors.black,
    iconTheme: IconThemeData(size: 30.0, color: Colors.white),
    titleTextStyle: TextStyle(
        color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17.0),
  );

  DrawerThemeData drawerThemeData = DrawerThemeData(
    backgroundColor: Colors.black,
    scrimColor: Colors.grey.withOpacity(0.18),
  );
}
