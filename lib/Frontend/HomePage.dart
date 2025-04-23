import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> scores = [];
  final TextEditingController finder = TextEditingController();
  String data = "Enter Team name to Search";
  var color = Colors.black;
  int offset = 0;
  bool isLoading = false;
  bool allDataLoaded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchLiveScores();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 &&
        !isLoading &&
        !allDataLoaded) {
      fetchLiveScores();
    }
  }

  Future<void> fetchLiveScores() async {
    setState(() => isLoading = true);

    final url = Uri.parse(
        'https://api.cricapi.com/v1/currentMatches?apikey=2d3e052a-f3d2-47b3-9cd1-fb6a10473224&offset=$offset');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final newMatches = jsonData['data'] ?? [];

        if (newMatches.isEmpty) {
          allDataLoaded = true;
        } else {
          setState(() {
            scores.addAll(newMatches);
            offset++;
          });
        }
      } else {
        print('Failed to fetch scores. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flash_on, color: Colors.yellowAccent),
            SizedBox(width: 10),
            Text(
              'Quick_Score',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 10,
        shadowColor: Colors.pinkAccent.withOpacity(0.4),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: finder,
                    decoration: InputDecoration(
                      hintText: data,
                      filled: true,
                      fillColor: Colors.white54,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: color),
                      ),
                      // Adjust contentPadding to make the TextField shorter
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0), // Modify this value
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      if (finder.text.trim().isEmpty) {
                        setState(() {
                          color = Colors.red;
                          data = "Cannot be Empty";
                        });
                      } else {
                        print('Searching for ${finder.text}');
                      }
                    },
                    icon: Icon(Icons.search, size: 30),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: scores.length + 1,
              itemBuilder: (context, index) {
                if (index == scores.length) {
                  return isLoading
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                      : SizedBox();
                }

                final match = scores[index];
                final teams = match['teams'] ?? [];
                final scoreList = match['score'] ?? [];

                final team1 = teams.isNotEmpty ? teams[0] : 'No team';
                final team2 = teams.length > 1 ? teams[1] : 'No team';

                final teamScores = {
                  'team1': 'Match not started',
                  'team2': 'Match not started',
                };

                if (scoreList.isNotEmpty) {
                  for (var s in scoreList) {
                    final inning = s['inning'] ?? '';
                    if (inning.contains(team1)) {
                      teamScores['team1'] =
                      '${s['r']}/${s['w']} in ${s['o']} overs';
                    } else if (inning.contains(team2)) {
                      teamScores['team2'] =
                      '${s['r']}/${s['w']} in ${s['o']} overs';
                    }
                  }
                }

                final t1Score = teamScores['team1']!;
                final t2Score = teamScores['team2']!;

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [Colors.orangeAccent, Colors.amber],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 5,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                        ),
                        height: screenHeight * 0.04,
                        alignment: Alignment.center,
                        child: Text(
                          match['name'] ?? 'No Series Name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: screenHeight * 0.03,
                        color: Colors.white60,
                        alignment: Alignment.center,
                        child: Text(
                          match['matchType'] ?? 'No Match Type',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    team1,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    t1Score,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    team2,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    t2Score,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        height: screenHeight * 0.05,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Text(
                              'Status:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                match['status'] ?? 'Status not available',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
