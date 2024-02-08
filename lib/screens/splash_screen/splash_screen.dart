import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../pagination/ui/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName='/splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {checkUserAndRedirect(context);});
  }

  void checkUserAndRedirect(context) async{
    await Future.delayed(Duration(seconds: 3,milliseconds: 500));
    Navigator.popAndPushNamed(context, HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height:w/2,
            width: w/2,
            child: Image.asset('assets/images/logo.png'),
          ),
          SizedBox(height: 30.0,),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                  'Pagination with Bloc',
                  textStyle: splashScreentextStyle,
                  speed: Duration(milliseconds: 150),
                  textAlign: TextAlign.center,
                cursor: ""
              ),
            ],
            isRepeatingAnimation: false,
          ),
        ],
      ),
    );
  }
}