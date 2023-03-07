import 'package:flutter/material.dart';
import 'package:pogo/HomeLoadingPage.dart';
import 'package:pogo/LandingPage.dart';
import 'package:pogo/Onboarding/SurveyLandingPage.dart';
import 'package:pogo/amplifyFunctions.dart';

class firstLoadingPage extends StatefulWidget {
  const firstLoadingPage({Key? key}) : super(key: key);

  @override
  State<firstLoadingPage> createState() => _firstLoadingPageState();
}

class _firstLoadingPageState extends State<firstLoadingPage> {

  @override
  void initState() {
    super.initState();
    configure(context);
  }

  void configure(context) async {
    bool check = await configureAmplify();
    if(check) {
      loginCheck(context);
    }
  }

  void loginCheck(context) async {
    if(await checkLoggedIn()) {
      if(await isSurveyCompleted()) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeLoadingPage(),
          ),
        );
      }
      else {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurveyLandingPage(),
          ),
        );
      }

    }
    else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LandingPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: const Scaffold(
        backgroundColor: Color(0xFFE1E1E1),
        body: Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: FittedBox(
              fit: BoxFit.fill,
              child: CircularProgressIndicator(
                backgroundColor: Color(0xFFE1E1E1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}