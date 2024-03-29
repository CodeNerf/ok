import 'dart:math';
import 'package:amplify_core/amplify_core.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pogo/amplifyFunctions.dart';
import 'package:pogo/awsFunctions.dart';
import 'dynamoModels/Ballot.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pogo/dynamoModels/Demographics/CandidateDemographics.dart';
import 'package:pogo/dynamoModels/IssueFactorValues/CandidateIssueFactorValues.dart';
import 'dynamoModels/MatchingStatistics.dart';

class Podium extends StatefulWidget {
  final List<CandidateDemographics> candidateStack;
  final Function(CandidateDemographics, List<CandidateDemographics>)
      updateBallot;
  final Ballot userBallot;
  final List<CandidateIssueFactorValues> candidateStackFactors;
  final Function(String) loadCandidateProfile;
  final List<MatchingStatistics> candidateStackStatistics;
  const Podium(
      {Key? key,
      required this.candidateStack,
      required this.candidateStackFactors,
      required this.candidateStackStatistics,
      required this.userBallot,
      required this.updateBallot,
      required this.loadCandidateProfile})
      : super(key: key);

  @override
  State<Podium> createState() => _PodiumState();
}

class _PodiumState extends State<Podium> {
  //search values
  final _searchController = TextEditingController();

  //card values
  late List<CandidateDemographics> _stack;
  late List<CandidateIssueFactorValues> _stackFactors;
  late List<MatchingStatistics> _stackStatistics;
  late int _stackLength;
  final SwipeableCardSectionController _cardController =
      SwipeableCardSectionController();
  int _count = 3;
  int _stackIterator = 0;

  //local,state,federal bar values
  final List<bool> _selections = List.generate(3, (_) => false);
  final Color _full = const Color(0xFFF3D433);
  final Color _empty = const Color(0xFF808080);
  Color _local = const Color(0xFFF3D433);
  Color _state = const Color(0xFF808080);
  Color _federal = const Color(0xFF808080);

  //list of valid candidates' names
  //static List<String> candidateList = <String>[];
  static List<String> _candidateList = [];

  //filtering

  @override
  void initState() {
    setState(() {
      _stackFactors = widget.candidateStackFactors;
      _stack = widget.candidateStack;
      _stackStatistics = widget.candidateStackStatistics;
      _stackLength = _stack.length;
      _candidateList = [];
    });
    _initializeSearchResults();
    super.initState();
  }

  void _initializeSearchResults() {
    for (int i = 0; i < _stackLength; i++) {
      _candidateList.add(_stack[i].candidateName);
    }
  }

  //suggests candidates when typing in search bar
  Future<List<String>> _candidateSearchOptions(String query) async {
    List<String> matches = [];
    matches.addAll(_candidateList);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  //card banner color
  Color _candidateColor(String party) {
    switch (party) {
      case 'Democrat':
        return const Color(0xFF3456CF);
      case 'Republican':
        return const Color(0xFFDE0100);
      case 'Libertarian':
        return const Color(0xFFFFD100);
      case 'Green':
        return const Color(0xFF508C1B);
    }
    return const Color(0xFFF9F9F9);
  }

  List<Widget> _initialCards() {
    List<Widget> initial = [];
    if (_stackLength == 1) {
      initial.add(_newCard(_stack[0], _stackStatistics[0]));
    } else if (_stackLength == 2) {
      initial.add(_newCard(_stack[0], _stackStatistics[0]));
      initial.add(_newCard(_stack[1], _stackStatistics[0]));
    } else if (_stackLength == 0) {
      return initial;
    } else {
      initial.add(_newCard(_stack[0], _stackStatistics[0]));
      initial.add(_newCard(_stack[1], _stackStatistics[1]));
      initial.add(_newCard(_stack[2], _stackStatistics[2]));
    }
    return initial;
  }

  List<Widget> _getRatingCircles(String candidateId) {
    CandidateIssueFactorValues current = _stackFactors
        .firstWhere((element) => element.candidateId == candidateId);
    List<num> candidateWeights = [
      current.climateWeight,
      current.drugPolicyWeight,
      current.economyWeight,
      current.educationWeight,
      current.gunPolicyWeight,
      current.healthcareWeight,
      current.housingWeight,
      current.immigrationWeight,
      current.policingWeight,
      current.reproductiveWeight
    ];
    List<dynamic> topIssues = [];
    num maxWeight = candidateWeights.reduce(max);
    int indexMaxWeight = candidateWeights.indexOf(maxWeight);
    for (int i = 0; i < 3; i++) {
      switch (indexMaxWeight) {
        case 0:
          topIssues.add('CLIMATE\n');
          topIssues.add(current.climateScore.toDouble());
          break;
        case 1:
          topIssues.add('DRUG\nPOLICY');
          topIssues.add(current.drugPolicyScore.toDouble());
          break;
        case 2:
          topIssues.add('ECONOMY\n');
          topIssues.add(current.economyScore.toDouble());
          break;
        case 3:
          topIssues.add('EDUCATION\n');
          topIssues.add(current.educationScore.toDouble());
          break;
        case 4:
          topIssues.add('GUN\nPOLICY');
          topIssues.add(current.gunPolicyScore.toDouble());
          break;
        case 5:
          topIssues.add('HEALTHCARE\n');
          topIssues.add(current.healthcareScore.toDouble());
          break;
        case 6:
          topIssues.add('HOUSING\n');
          topIssues.add(current.housingScore.toDouble());
          break;
        case 7:
          topIssues.add('IMMIGRATION\n');
          topIssues.add(current.immigrationScore.toDouble());
          break;
        case 8:
          topIssues.add('POLICING\n');
          topIssues.add(current.policingScore.toDouble());
          break;
        case 9:
          topIssues.add('REPRODUCTIVE\nRIGHTS');
          topIssues.add(current.reproductiveScore.toDouble());
          break;
      }
      candidateWeights[indexMaxWeight] = 0;
      maxWeight = candidateWeights.reduce(max);
      indexMaxWeight = candidateWeights.indexOf(maxWeight);
    }
    List<Widget> circles = [];
    circles.add(_ratingCircles('${topIssues[0]}\n', topIssues[1]));
    circles.add(_ratingCircles('${topIssues[2]}\n', topIssues[3]));
    circles.add(_ratingCircles('${topIssues[4]}\n', topIssues[5]));
    return circles;
  }

  //returns the candidate's experience
  String _candidateExperience(String careerStart) {
    String experience = '';
    DateTime start = DateTime.parse(careerStart);
    DateTime currentDate = DateTime.now();
    int days = currentDate.difference(start).inDays;
    if (days > 364) {
      int years = days ~/ 365;
      //years
      experience = '$years years experience';
    } else if (days > 29) {
      //months
      int months = days ~/ 30;
      experience = '$months months experience';
    } else {
      experience = '$days days experience';
    }
    return experience;
  }

  void _goToCandidateProfile(String name) async {
    widget.loadCandidateProfile(name);
  }

  void _addCandidate(CandidateDemographics candidate) async {
    _stack.remove(candidate);
    widget.updateBallot(candidate, _stack);
  }

  Widget _newCard(CandidateDemographics candidate, MatchingStatistics stats) {
    return Card(
      //card properties
      color: const Color(0xFFF9F9F9),
      margin: const EdgeInsets.fromLTRB(60, 10, 60, 60),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: InkWell(
        onTap: () async {
          _goToCandidateProfile(candidate.candidateName);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //candidate picture
            Expanded(
              flex: 40,
              child: Container(
                color: _candidateColor(candidate.politicalAffiliation),
                width: double.infinity,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProfileAvatar(
                                '',
                                radius: 60,
                                elevation: 5,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image(
                                    image:
                                        NetworkImage(candidate.profileImageURL),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Stack(
                              children: [
                                const FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image(
                                    width: 50,
                                    height: 50,
                                    image: AssetImage('assets/flame.png'),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 18, 2, 0),
                                  child: Text(
                                    "${((_stackStatistics.firstWhere((element) => element.candidateId == candidate.id)).rSquared * 100).round()}%",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //candidate name
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: AutoSizeText(
                  candidate.candidateName,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            //candidate position, city
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: AutoSizeText(
                  '${candidate.runningPosition}  •  ${candidate.city}',
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: Color(0xFF57636C),
                  ),
                ),
              ),
            ),

            //party, experience
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: AutoSizeText(
                  '${candidate.politicalAffiliation}  •  ${_candidateExperience(candidate.careerStartYear)}',
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: Color(0xFF57636C),
                  ),
                ),
              ),
            ),

            //candidate top issues
            Expanded(
              flex: 35,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _getRatingCircles(candidate.id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 13,
          //podium background
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF9F9F9),
              image: DecorationImage(
                image: AssetImage('assets/podiumPageBackgroundImage.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: SizedBox(
                          height: 22,
                          width: 22,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Image(
                              image: AssetImage('assets/podium x.png'),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Image(
                              image: AssetImage('assets/podium plus.png'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //search bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                labelText: 'Search',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                            suggestionsCallback: (query) async {
                              return _candidateSearchOptions(query);
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            noItemsFoundBuilder: (context) => const Text(
                              'No Candidates Found',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            transitionBuilder:
                                (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            onSuggestionSelected: (suggestion) {
                              _goToCandidateProfile(suggestion);
                            },
                          ),
                        ),
                      ),
                    ),
                    //candidate cards
                    SwipeableCardsSection(
                      cardController: _cardController,
                      context: context,
                      items: _initialCards(),
                      onCardSwiped: (dir, index, widget) {
                        if (_stackLength > 3 && _stack.isNotEmpty) {
                          //if the three buffer cards are not yet reached
                          if (_count < _stackLength) {
                            _cardController.addItem(_newCard(
                                _stack[_count], _stackStatistics[_count]));
                          }
                          if (dir == Direction.right) {
                            _addCandidate(_stack[_stackIterator]);
                            _stackLength--;
                          } else {
                            if (_count < _stackLength) {
                              putDeferred(_stack[_stackIterator].id);
                              if (_count == _stackLength - 1) {
                                _count = 0;
                              } else {
                                _count++;
                              }
                            } else {
                              _count = 0;
                            }
                            if (_stackIterator >= _stackLength - 1) {
                              _stackIterator = 0;
                            } else {
                              _stackIterator++;
                            }
                          }
                        } else if (_stack.isNotEmpty && _stackLength == 3) {
                          //edge of buffer
                          int temp = _stackIterator;
                          if (dir == Direction.right) {
                            _stackLength = 2;
                            _addCandidate(_stack[temp]);
                          } else {
                            if (_count == 2) {
                              _count = 0;
                              if (_stackIterator == 2) {
                                _stackIterator = 0;
                                _cardController.addItem(
                                    _newCard(_stack[2], _stackStatistics[2]));
                              } else {
                                putDeferred(_stack[_stackIterator].id);
                                if (_count < _stackLength) {
                                  if (_count == _stackLength - 1) {
                                    _count = 0;
                                  } else {
                                    _count++;
                                  }
                                } else {
                                  _count = 0;
                                }
                                if (_stackIterator >= _stackLength - 1) {
                                  _stackIterator = 0;
                                } else {
                                  _stackIterator++;
                                }
                                _stackIterator = 2;
                                _cardController.addItem(
                                    _newCard(_stack[0], _stackStatistics[0]));
                              }
                            } else if (_count == 1) {
                              _count = 2;
                              if (_stackIterator == 1) {
                                _stackIterator = 2;
                                _cardController.addItem(
                                    _newCard(_stack[1], _stackStatistics[1]));
                              } else {
                                _stackIterator = 1;
                                _cardController.addItem(
                                    _newCard(_stack[2], _stackStatistics[2]));
                              }
                            } else if (_count == 0) {
                              _count = 1;
                              if (_stackIterator == 0) {
                                _stackIterator = 1;
                                _cardController.addItem(
                                    _newCard(_stack[0], _stackStatistics[0]));
                              } else {
                                _stackIterator = 0;
                                _cardController.addItem(
                                    _newCard(_stack[1], _stackStatistics[1]));
                              }
                            } else {
                              _count = 1;
                              _stackIterator = 1;
                              _cardController.addItem(
                                  _newCard(_stack[0], _stackStatistics[0]));
                            }
                          }
                        } else if (_stack.isNotEmpty && _stackLength == 2) {
                          if (widget != null) {
                            if (dir == Direction.right) {
                              _stackLength = 1;
                              _addCandidate(_stack[_stackIterator]);
                            } else {
                              putDeferred(_stack[_stackIterator].id);
                              if (_stackIterator == 0) {
                                _stackIterator = 1;
                                _cardController.addItem(
                                    _newCard(_stack[0], _stackStatistics[0]));
                              } else {
                                _stackIterator = 0;
                                _cardController.addItem(
                                    _newCard(_stack[1], _stackStatistics[1]));
                              }
                            }
                          }
                        } else if (_stack.isNotEmpty && _stackLength == 1) {
                          if (widget != null) {
                            if (dir == Direction.left) {
                              putDeferred(_stack[_stackIterator].id);
                              _cardController.addItem(
                                  _newCard(_stack[0], _stackStatistics[0]));
                            } else {
                              _stackLength = 0;
                              _addCandidate(_stack[0]);
                            }
                          }
                        }
                      },
                      enableSwipeUp: false,
                      enableSwipeDown: false,
                    ),
                    //alert and remove filter button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                            child: GestureDetector(
                              onTap: () {
                                _showAlert(context);
                              },
                              child: const Icon(
                                CupertinoIcons.question_circle,
                                size: 25,
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _ratingCircles(String name, double rating) {
    return CircularPercentIndicator(
      radius: 25,
      lineWidth: 6,
      progressColor: const Color(0xFFF3D433),
      backgroundColor: const Color(0xFF8B9DDE),
      footer: Text(
        name,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      percent: rating / 5,
      center: Text(
        '$rating',
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _showAlert(BuildContext context) {
    AlertDialog alert = const AlertDialog(
      content: Text(
          'Swipe left to skip the current candidate.\nSwipe right to add the candidate to your ballot.\n\nEach candidate displays their ratings on the 3 political issues that are most important to them. A low rating means that the candidate leans more to the left on that issue. A high rating means that the candidate leans more to the right on that issue.\n\nThe candidates can be filtered by their position through clicking an empty circle in the ballot.'),
    );
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
