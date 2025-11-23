import 'dart:convert';
import 'package:app_pawpal/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:app_pawpal/views/home/sc_home.dart';
import 'package:app_pawpal/widgets/auth_listtile.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late double scHeight;
  late double scWidth;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    scHeight = MediaQuery.of(context).size.height;
    scWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          scWidth * 0.05, 0, scWidth * 0.05, scHeight * 0.02),
      child: Column(
        children: [
          // Name Field
          Card(
            child: AuthListTile(
              controller: nameController,
              leadingIcon: Icons.person,
              title: 'User Name',
              subtitle: 'Enter User Name',
              deny: RegExp(r'[^a-zA-Z\s]'),
            ),
          ),

          const SizedBox(height: 10),

          // Email Field
          Card(
            child: AuthListTile(
              controller: emailController,
              leadingIcon: Icons.email,
              title: 'Email Address',
              subtitle: 'Enter Email Address',
              deny: RegExp(r'[^a-zA-Z0-9@._-]'),
            ),
          ),

          const SizedBox(height: 10),

          // Phone Number Field
          Card(
            child: AuthListTile(
              controller: phoneNumberController,
              leadingIcon: Icons.phone,
              title: 'Phone Number',
              subtitle: 'Enter Phone Number',
              maxChar: 15,
              deny: RegExp(r'[^0-9]'),
            ),
          ),

          const SizedBox(height: 10),

          // Password Field
          Card(
            child: AuthListTile(
              controller: passwordController,
              leadingIcon: Icons.lock,
              title: 'Password',
              subtitle: 'Enter Password',
              maxChar: 20,
              deny: RegExp(r'[^a-zA-Z0-9!@#$%^&*._-]'),
              obscureText: true,
            ),
          ),

          const SizedBox(height: 10),

          // Confirm Password Field
          Card(
            child: AuthListTile(
              controller: confirmPasswordController,
              leadingIcon: Icons.lock,
              title: 'Confirm Password',
              subtitle: 'Re-enter Password',
              maxChar: 20,
              deny: RegExp(r'[^a-zA-Z0-9!@#$%^&*._-]'),
              obscureText: true,
            ),
          ),

          const Expanded(child: SizedBox()),

          // Register Button
          SizedBox(
            width: scWidth * 0.45,
            child: ElevatedButton(
              onPressed: _registerDialog,
              child: const Text(
                "Register",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _registerDialog() {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String phone = phoneNumberController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all fields'),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 2000),
      ));
      return;
    }
    if (password.length < 6 || password.length > 20) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password must be between 6 and 20 characters'),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 2000),
      ));
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Passwords do not match'),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 2000),
      ));
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register this account?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _registerUser(email, password, name, phone);
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
        content: const Text('Are you sure you want to register this account?'),
      ),
    );
  }

  void _registerUser(
      String email, String password, String name, String phone) async {
    setState(() {
      isLoading = true;
    });
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Registering...'),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );
    await http.post(
      Uri.parse('http://10.19.36.2/app_pawpal/api/register.php'),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        var resarray = jsonDecode(jsonResponse);
        if (resarray['status'] == 'success') {
          User user = User.fromJson(resarray['data'][0]);
          if (!mounted) return;
          SnackBar snackBar = const SnackBar(
            content: Text('Registration successful'),
          );
          if (isLoading) {
            if (!mounted) return;
            Navigator.pop(context);
            setState(() {
              isLoading = false;
            });
          }
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      user: user,
                    )),
          );
        } else {
          if (!mounted) return;
          SnackBar snackBar = SnackBar(content: Text(resarray['message']));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        if (!mounted) return;
        SnackBar snackBar = const SnackBar(
          content: Text('Registration failed. Please try again.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        if (!mounted) return;
        SnackBar snackBar = const SnackBar(
          content: Text('Request timed out. Please try again.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );

    if (isLoading) {
      if (!mounted) return;
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
    }
  }
}
