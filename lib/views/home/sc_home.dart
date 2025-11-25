import 'package:app_pawpal/models/user.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final User? user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    User user = widget.user!;
    String name = user.name!;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        _backButtonPressed(context, didPop);
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome Home, $name!',
                  style: const TextStyle(fontSize: 20)),
              TextButton(
                onPressed: () => _logoutDialog(context),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _logoutDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Logout')),
          ],
        );
      });
}

void _backButtonPressed(BuildContext context, bool didPop) {
  if (didPop) {
    return;
  }
  _logoutDialog(context);
}
