import 'package:flutter/material.dart';
import 'dart:async';
import 'package:quick_catch/Frontend/HomePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String loadingText = "Loading...";

  @override
  void initState() {
    super.initState();

    // Change text to "Finishing up..." after 4 seconds
    Timer(Duration(seconds: 4), () {
      setState(() {
        loadingText = "Finishing up...";
      });
    });

    // Navigate to Home after 5 seconds
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(

      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.pink], // Match gradient with AppBar
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Container with a standout background color
            AnimatedContainer(
              duration: Duration(seconds: 2),
              curve: Curves.easeInOut,
              height: 0.25 * screenHeight,
              width: 0.50 * screenWidth,
              decoration: BoxDecoration(
                // Remove background color for transparency or make it stand out
                color: Colors.transparent, // Make container background transparent
                borderRadius: BorderRadius.circular(80),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withOpacity(0.6),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Quick Scoring Around You',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins', // Custom Font
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 30),

            // Circular Progress Indicator with custom size
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 4,
              ),
            ),

            SizedBox(height: 20),

            // Loading Text with fade-in effect
            AnimatedOpacity(
              opacity: loadingText == "Loading..." ? 1.0 : 0.8,
              duration: Duration(seconds: 1),
              child: Text(
                loadingText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
