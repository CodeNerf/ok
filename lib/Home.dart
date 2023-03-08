import 'package:flutter/material.dart';
import 'package:pogo/dynamoModels/UserDemographics.dart';
import 'dynamoModels/Ballot.dart';
import 'dynamoModels/CandidateDemographics.dart';
import 'UserProfile.dart';
import 'VoterGuide.dart';
import 'CandidateInfo.dart';
import 'Podium.dart';
import 'dynamoModels/UserIssueFactorValues.dart';
import 'user.dart';

class Home extends StatefulWidget {
  final UserDemographics currentUserDemographics;
  final UserIssueFactorValues currentUserFactors;
  final List<CandidateDemographics> candidateStack;
  final Ballot userBallot;
  const Home({Key? key, required this.currentUserFactors, required this.candidateStack, required this.currentUserDemographics, required this.userBallot}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String PogoLogo = 'assets/Pogo_logo_horizontal.png';
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  //TODO: implement user issues object
  //objects
  user currentUser = user.all('','','','','');
  List<CandidateDemographics> ballotStack = [];
  late Ballot userBallot;
  late UserIssueFactorValues currentUserFactors;
  late List<CandidateDemographics> candidateStack;
  late UserDemographics currentUserDemographics;
  late List<Widget> _widgetOptions;

  updateStack(List<CandidateDemographics> stack) {
    setState(() {
      candidateStack = stack;
    });
  }

  updateBallot(Ballot b, CandidateDemographics candidate) {
    setState(() {
      userBallot = b;
    });
    ballotStack.add(candidate);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    currentUserFactors = widget.currentUserFactors;
    candidateStack = widget.candidateStack;
    currentUserDemographics = widget.currentUserDemographics;
    userBallot = widget.userBallot;
    setState(() {
      _widgetOptions = <Widget>[VoterGuide(), Podium(candidateStack: candidateStack, updateStack: updateStack, userBallot: userBallot, updateBallot: updateBallot), CandidateInfo(userBallot: userBallot, candidateStack: candidateStack, ballotStack: ballotStack), UserProfile(currentUserFactors: currentUserFactors, currentUserDemographics: currentUserDemographics,)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFE5E5E5),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Align(
            alignment: Alignment.center,
            child: Image(
              image: AssetImage(PogoLogo),
              width: 150,
            ),
          ),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 0,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey[650],
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/briefcase.png'),
              ),
              label: 'Voter Guide',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/speech.png'),
              ),
              label: 'Podium',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/vote.png'),
              ),
              label: 'Ballot',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/user.png'),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
