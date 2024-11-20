import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot/resources/auth_method.dart';
import 'package:iot/widgets/custom_button.dart';
import 'package:iot/utils/utils.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthMethods _authMethods = AuthMethods();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _isLogin = true; // Toggle between login and sign-up screens
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Start to Control your world',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SizedBox(
                    width: 150, // set the desired width
                    height: 150, // set the desired height
                    child: Image.asset('assets/images/img.png'),
                  ),
                ),

                if (!_isLogin)
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                  text: _isLogin ? 'Login' : 'Sign Up',
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    bool res;
                    if (_isLogin) {
                      // Email/password login
                      res = await _authMethods.signInWithEmail(
                        email: _emailController.text,
                        password: _passwordController.text,
                        context: context,
                      );
                      if (res) {
                        Navigator.pushNamed(context, '/home');
                      }
                    } else {
                      // Email/password sign-up with OTP verification
                      res = await _authMethods.signUpWithEmail(
                        email: _emailController.text,
                        password: _passwordController.text,
                        username: _usernameController.text,
                        context: context,
                      );
                      if (res) {
                        showSnackBar(
                            context, 'Check your email to verify your account.');
                        setState(() {
                          _isLogin = true; // Switch to login screen after sign-up
                        });
                      }
                    }
                    setState(() => _isLoading = false);
                  },
                ),
                const Text('Or continue with'),
                CustomButton(
                  text: 'Google Sign In',
                  onPressed: () async {
                    bool res = await _authMethods.signInWithGoogle(context);
                    if (res) {
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                ),

                TextButton(
                  onPressed: () {
                    setState(() => _isLogin = !_isLogin);
                  },
                  child: Text(_isLogin
                      ? 'Don’t have an account? Sign Up'
                      : 'Already have an account? Login'),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
