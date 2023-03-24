import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pogo/amplifyFunctions.dart';
import '../HomeLoadingPage.dart';
import '../dynamoModels/UserDemographics.dart';
import '../awsFunctions.dart';
import '../dynamoModels/UserIssueFactorValues.dart';
import 'VoterInfo.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Issues extends StatefulWidget {
  final UserIssueFactorValues ratings;
  final UserDemographics answers;
  final int issuesIndex;
  late final Widget nextPage = HomeLoadingPage(
    user: answers,
  );
  late final Widget lastPage = VoterInfo(
    ratings: ratings,
    answers: answers,
    issuesIndex: issuesIndex,
  );
  Issues({Key? key, required this.ratings, required this.answers, required this.issuesIndex})
      : super(key: key);

  @override
  State<Issues> createState() => _IssuesState();
}

class _IssuesState extends State<Issues> {
  //TODO: fix text align/size in card


  FixedExtentScrollController _extentScrollController = FixedExtentScrollController();


  final String _pogoLogo = 'assets/Pogo_logo_horizontal.png';
  late int _issueIndex;
  final List<String> _issuesLogo = [
    'assets/gunPolicyPogo.jpeg',
    'assets/climatePogo.jpg',
    'assets/educationPogo.jpeg',
    'assets/marijuana.png',
    'assets/healthcarePogo.jpg',
    'assets/housingPogo.jpg',
    'assets/economyPogo.jpg',
    'assets/immigrationPogo.jpg',
    'assets/policingPogo.jpg',
    'assets/reproductiveHealthPogo.jpg'
  ];
  final List<String> _issuesText = [
    'GUN POLICY',
    'CLIMATE CHANGE',
    'EDUCATION',
    'DRUG POLICY',
    'HEALTHCARE',
    'HOUSING',
    'ECONOMY',
    'IMMIGRATION',
    'POLICING',
    'REPRODUCTIVE RIGHTS'
  ];
  int _nextButtonColor = 0xFF808080;
  final int _backgroundColor = 0xFFE1E1E1;
  double _alignRating = 0;
  double _valueRating = 0;
  late double _backOpacity;
  late double _forwardOpacity;
  final Color _ratingBarColor = Colors.black;
  final List<String> _leftAlignText = [
    'Gun Control',
    'Acceptance',
    'Public',
    'Legalization',
    'Government Funded',
    'Affordable Housing',
    'Market Regulation',
    'Inclusive',
    'Divestment\nReallocation',
    'Abortion + \nContraceptive Rights'
  ];
  final List<String> _rightAlignText = [
    'Gun Rights',
    'Doubt',
    'School Choice',
    'Criminalization',
    'Private',
    'Market Rat\nHousing',
    'Market\nDeregulation',
    'Exclusive',
    'Investment',
    'Abortion + \nContraceptive Restrictions'
  ];

  @override
  void initState() {
    super.initState();
    _issueIndex = widget.issuesIndex;
    _alignRating = widget.ratings.gunPolicyScore.toDouble();
    _valueRating = widget.ratings.gunPolicyWeight.toDouble();
    //check if any values are 0 (0 means user never completed survey yet) if not make button yellow
    List<num> scores = [widget.ratings.gunPolicyScore, widget.ratings.policingScore, widget.ratings.reproductiveScore, widget.ratings.climateScore, widget.ratings.educationScore, widget.ratings.drugPolicyScore, widget.ratings.immigrationScore, widget.ratings.economyScore, widget.ratings.healthcareScore, widget.ratings.housingScore];
    if (!scores.contains(0)) {
      _nextButtonColor = 0xFFF3D433;
    }
    if(_issueIndex > 0 && _issueIndex < 9) {
      _backOpacity = 1;
      _forwardOpacity = 1;
    }
    else if(_issueIndex == 0) {
      _backOpacity = 0;
      _forwardOpacity = 1;
    }
    else {
      _forwardOpacity = 0;
      _backOpacity = 1;
    }
  }

  void _setRatings() {
    switch (_issueIndex) {
      case 0:
        _alignRating = widget.ratings.gunPolicyScore.toDouble();
        _valueRating = widget.ratings.gunPolicyWeight.toDouble();
        break;
      case 1:
        _alignRating = widget.ratings.climateScore.toDouble();
        _valueRating = widget.ratings.climateWeight.toDouble();
        break;
      case 2:
        _alignRating = widget.ratings.educationScore.toDouble();
        _valueRating = widget.ratings.educationWeight.toDouble();
        break;
      case 3:
        _alignRating = widget.ratings.drugPolicyScore.toDouble();
        _valueRating = widget.ratings.drugPolicyWeight.toDouble();
        break;
      case 4:
        _alignRating = widget.ratings.healthcareScore.toDouble();
        _valueRating = widget.ratings.healthcareWeight.toDouble();
        break;
      case 5:
        _alignRating = widget.ratings.housingScore.toDouble();
        _valueRating = widget.ratings.housingWeight.toDouble();
        break;
      case 6:
        _alignRating = widget.ratings.economyScore.toDouble();
        _valueRating = widget.ratings.economyWeight.toDouble();
        break;
      case 7:
        _alignRating = widget.ratings.immigrationScore.toDouble();
        _valueRating = widget.ratings.immigrationWeight.toDouble();
        break;
      case 8:
        _alignRating = widget.ratings.policingScore.toDouble();
        _valueRating = widget.ratings.policingWeight.toDouble();
        break;
      case 9:
        _alignRating = widget.ratings.reproductiveScore.toDouble();
        _valueRating = widget.ratings.reproductiveWeight.toDouble();
        break;
    }
  }

  void _updateAlignRating(double rating) {
    switch (_issueIndex) {
      case 0:
        widget.ratings.gunPolicyScore = rating;
        break;
      case 1:
        widget.ratings.climateScore = rating;
        break;
      case 2:
        widget.ratings.educationScore = rating;
        break;
      case 3:
        widget.ratings.drugPolicyScore = rating;
        break;
      case 4:
        widget.ratings.healthcareScore = rating;
        break;
      case 5:
        widget.ratings.housingScore = rating;
        break;
      case 6:
        widget.ratings.economyScore = rating;
        break;
      case 7:
        widget.ratings.immigrationScore = rating;
        break;
      case 8:
        widget.ratings.policingScore = rating;
        break;
      case 9:
        widget.ratings.reproductiveScore = rating;
        break;
    }
    _alignRating = rating;
    _updateButton();
  }

  void _updateValueRating(double rating) {
    switch (_issueIndex) {
      case 0:
        widget.ratings.gunPolicyWeight = rating;
        break;
      case 1:
        widget.ratings.climateWeight = rating;
        break;
      case 2:
        widget.ratings.educationWeight = rating;
        break;
      case 3:
        widget.ratings.drugPolicyWeight = rating;
        break;
      case 4:
        widget.ratings.healthcareWeight = rating;
        break;
      case 5:
        widget.ratings.housingWeight = rating;
        break;
      case 6:
        widget.ratings.economyWeight = rating;
        break;
      case 7:
        widget.ratings.immigrationWeight = rating;
        break;
      case 8:
        widget.ratings.policingWeight = rating;
        break;
      case 9:
        widget.ratings.reproductiveWeight = rating;
        break;
    }
    _valueRating = rating;
    _updateButton();
  }

  void _updateButton() {
    if (widget.ratings.reproductiveScore != 0 || _issueIndex == 9) {
      _nextButtonColor = 0xFFF3D433;
    }
    if(_issueIndex > 0 && _issueIndex < 9) {
      _backOpacity = 1;
      _forwardOpacity = 1;
    }
    else if(_issueIndex == 0) {
      _backOpacity = 0;
    }
    else {
      _forwardOpacity = 0;
    }
    setState(() {});
  }

  void _checkRatings(context, String backOrForward) async {
    //THIS IS CALLED WHEN NEXT ARROW ICON IS CLICKED
    if (_alignRating == 0) {
      _updateAlignRating(1);
    }
    if (_valueRating == 0) {
      _updateValueRating(1);
    }
    if(backOrForward == "back") {
      if(_issueIndex != 0) {
        _issueIndex--;
        _setRatings();
        _updateButton();
      }
    }
    else {
      if(_issueIndex != 9) {
        _issueIndex++;
        _setRatings();
        _updateButton();
      }
    }
    if(_issueIndex == 9) {
      widget.ratings.reproductiveScore = 1;
      widget.ratings.reproductiveWeight = 1;
    }
  }

  void _endSurvey(context) async {
    if(widget.ratings.reproductiveScore != 0) {
      widget.answers.surveyCompletion = true;
      try {
        await Future.wait([
          putUserDemographics(widget.answers),
          putUserIssueFactorValues(widget.ratings),
        ]).then((List<dynamic> values) {
          safePrint("UserDemographics and UserIssueFactorValues updated");
        });
      } catch (e) {
        safePrint("Issues.dart: $e");
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeLoadingPage(user: widget.answers),
        ),
      );
    }
  }

  void _goBack() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VoterInfo(
          ratings: widget.ratings,
          answers: widget.answers,
          issuesIndex: _issueIndex,
        ),
      ),
    );
  }

  double setInitialAlignScaleValue() {
    if(_alignRating == 0) {
      return 1;
    }
    return _alignRating;
  }

  double setInitialCareScaleValue() {
    if(_valueRating == 0) {
      return 1;
    }
    return _valueRating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => _goBack(),
        ),
        centerTitle: true,
        title: Image(
          image: AssetImage(_pogoLogo),
          width: 150,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 20),
              child: SizedBox(
                child: AutoSizeText(
                  'Choose where you stand and how concerned you are with popular issues',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                    color: Color(0xFF0E0E0E),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //last card button
                GestureDetector(
                  onTap: () {
                    _checkRatings(context, "back");
                  },
                  child: Opacity(
                    opacity: _backOpacity,
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                    ),
                  ),
                ),
                //issue card
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Card(
                    color: const Color(0xFFD9D9D9),
                    elevation: 10,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        //issue pic
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            height: MediaQuery.of(context).size.height * 0.60 / 3,
                            width: MediaQuery.of(context).size.width * 0.65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade600,
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: const Offset(3, 3),
                                ),
                              ],
                            ),
                            child: Image(
                              image: AssetImage(
                                _issuesLogo[_issueIndex],
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        //name of issue
                        AutoSizeText(
                          _issuesText[_issueIndex],
                          maxLines: 1,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                            color: Color(0xFF0E0E0E),
                          ),
                        ),
                        //where do you align
                        const Text(
                          'Where do you align?',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Color(0xFF57636C),
                          ),
                        ),
                        //align slider
                        Slider(
                          divisions: 4,
                          thumbColor: const Color(0xFFF3D433),
                          activeColor: const Color(0xFF0E0E0E),
                          inactiveColor: const Color(0xFF0E0E0E),
                          min: 1,
                          max: 5,
                          value: setInitialAlignScaleValue(),
                          onChangeEnd: (double value) {
                            _updateAlignRating(value);
                          },
                          onChanged: (double value) { },
                        ),
                        //align slider text
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Row(
                            children: [
                              Text(
                                _leftAlignText[_issueIndex],
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              const Spacer(),
                              Text(_rightAlignText[_issueIndex],
                                  style: const TextStyle(
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                        ),
                        //how much do you care
                        const Text(
                          'How much do you care?',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Color(0xFF57636C),
                          ),
                        ),
                        //care slider
                        Slider(
                          divisions: 4,
                          thumbColor: const Color(0xFFF3D433),
                          activeColor: const Color(0xFF0E0E0E),
                          inactiveColor: const Color(0xFF0E0E0E),
                          min: 1,
                          max: 5,
                          value: setInitialCareScaleValue(),
                          onChangeEnd: (double value) {
                            _updateValueRating(value);
                          },
                          onChanged: (double value) { },
                        ),
                        //care slider text
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Row(
                            children: const [
                              Text(
                                'Very Little',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Spacer(),
                              Text(
                                  'Extremely',
                                  style: TextStyle(
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //next card button
                GestureDetector(
                  onTap: () {
                    _checkRatings(context, "");
                  },
                  child: Opacity(
                    opacity: _forwardOpacity,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            //Next question button
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 20),
              child: GestureDetector(
                onTap: () async {
                  _endSurvey(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(_nextButtonColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'PoGo',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
