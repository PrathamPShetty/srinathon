import 'package:farm_link_ai/core/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import 'package:farm_link_ai/consts/assets.dart';

import '../../utils/hive_utils.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<Login> {
  bool isFarmer = true;
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  loginAnimation, // Add a farm-related animation
                  height: 150,
                ),
                Text(
                  isLogin ? "Login" : "Sign Up",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: Text("ServiceProvider"),
                      selected: isFarmer,
                      onSelected: (selected) {
                        setState(() {
                          isFarmer = selected;
                        });
                      },
                    ),
                    SizedBox(width: 10),
                    ChoiceChip(
                      label: Text("Customer"),
                      selected: !isFarmer,
                      onSelected: (selected) {
                        setState(() {
                          isFarmer = !selected;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (isLogin) buildLoginFields(),
                if (!isLogin) buildSignupFields(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: ()async {
                  await HiveUtils.saveUserType(isFarmer);

                   GoRouter.of(context).go(isFarmer?'/farmer':'/customer');
                  },
                  child: Text(isLogin ? "Login" : "Sign Up"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(
                    isLogin ? "Don't have an account? Sign Up" : "Already have an account? Login",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginFields() {
    return Column(
      children: [
        if (isFarmer) ...[
          const TextField(
            decoration: InputDecoration(labelText: "Name"),
            keyboardType: TextInputType.number,
          ),
        ] else ...[
          const TextField(
            decoration: InputDecoration(labelText: "Email"),
            keyboardType: TextInputType.emailAddress,
          ),const TextField(
            decoration: InputDecoration(labelText: "Service"),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
        const TextField(
          decoration: InputDecoration(labelText: "Password"),
          obscureText: true,
        ),
      ],
    );
  }

  Widget buildSignupFields() {
    return Column(
      children: [
        if (isFarmer) ...[

          const TextField(
            decoration: InputDecoration(labelText: "Name"),
          ),
          TextField(
            decoration: InputDecoration(labelText: "Email"),
            keyboardType: TextInputType.emailAddress,
          ),  TextField(
            decoration: InputDecoration(labelText: "Service"),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Password"),
            obscureText: true,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Phone Number"),
            keyboardType: TextInputType.phone,
          ),
        ] else ...[
          TextField(
            decoration: InputDecoration(labelText: "Name"),
          ),
          TextField(
            decoration: InputDecoration(labelText: "Email"),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Password"),
            obscureText: true,
          ),
          TextField(
            decoration: InputDecoration(labelText: "Phone Number"),
            keyboardType: TextInputType.phone,
          ),
        ],
      ],
    );
  }
}
