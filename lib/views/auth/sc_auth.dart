import 'package:app_pawpal/views/auth/login.dart';
import 'package:app_pawpal/views/auth/register.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final PageController _pageViewController = PageController();
  late double scHeight;
  late double scWidth;

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    scHeight = MediaQuery.of(context).size.height;
    scWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Title
            Positioned(
              width: scWidth,
              height: scHeight * 0.15,
              child: const Center(
                child: Text(
                  "PawPal",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5,
                  ),
                ),
              ),
            ),
            // Cat Image
            Positioned(
              top: scHeight * 0.1,
              left: scWidth * 0.05,
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                height: scHeight * 0.15,
                width: scWidth * 0.3,
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  'assets/images/cat.png',
                  scale: 6,
                  fit: BoxFit.none,
                  alignment: const Alignment(-0.1, -1.8),
                ),
              ),
            ),
            // Rabbit Image
            Positioned(
              top: scHeight * 0.1,
              left: scWidth * 0.35,
              height: scHeight * 0.15,
              width: scWidth * 0.3,
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  'assets/images/rabbit.png',
                  scale: 6,
                  fit: BoxFit.none,
                  alignment: const Alignment(-0.1, -1.4),
                ),
              ),
            ),
            // Dog Image
            Positioned(
              top: scHeight * 0.1,
              left: scWidth * 0.65,
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                height: scHeight * 0.15,
                width: scWidth * 0.3,
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  'assets/images/dog.png',
                  scale: 5,
                  fit: BoxFit.none,
                  alignment: const Alignment(-0.1, -1.5),
                ),
              ),
            ),
            // Center White Container with Login/Register Forms
            Positioned(
                top: scHeight * 0.25,
                left: scWidth * 0.1,
                child: Container(
                  width: scWidth * 0.8,
                  height: scHeight * 0.55,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFF8B5E3B), width: 3),
                      borderRadius: BorderRadius.zero),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(scHeight * 0.01),
                            child: TextButton(
                              onPressed: navigatePage(0),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: _currentIndex == 0
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(scHeight * 0.01),
                            child: TextButton(
                              onPressed: navigatePage(1),
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontWeight: _currentIndex == 1
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _pageViewController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          children: const <Widget>[
                            LoginView(),
                            RegisterView(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // 0 - Login, 1 - Register
  navigatePage(int index) => () {
        setState(() {
          _currentIndex = index;
        });
        _pageViewController.animateToPage(index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      };
}
