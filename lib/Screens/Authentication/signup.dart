import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:splitwise_app_replica/services/auth.dart';
import 'package:splitwise_app_replica/services/database.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final _fullNameFocusNode = FocusNode();
  String error = '';
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  // bool _isProcessing = false;
  final _formkey = GlobalKey<FormState>();

  String _selectedCountryCode = '+91';
  final List<String> _countryCodes = [
    '+1',
    '+91',
    '+44',
    '+86',
    '+81',
    '+55',
    '+61',
    '+64',
    '+81',
  ];

  @override
  void dispose() {
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneFocusNode.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _requestfullNameFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_fullNameFocusNode);
    });
  }

  void _requestEmailFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_emailFocusNode);
    });
  }

  void _requestPasswordFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_passwordFocusNode);
    });
  }

  void _requestphoneFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_phoneFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final BuildContext _context = context;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Sign Up'),
        backgroundColor: const Color.fromRGBO(76, 187, 155, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _fullNameController,
                  focusNode: _fullNameFocusNode,
                  onTap: _requestfullNameFocus,
                  validator: (val) {
                    if (val == null) {
                      return "Enter an non null Name";
                    } else {
                      return val.isEmpty ? "Enter a Name" : null;
                    }
                  },
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(76, 187, 155, 1),
                        width: 2,
                      ),
                    ),
                    labelText: 'Full Name',
                    labelStyle: TextStyle(
                      color: _fullNameFocusNode.hasFocus
                          ? const Color.fromRGBO(76, 187, 155, 1)
                          : Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  onTap: _requestEmailFocus,
                  validator: (val) {
                    if (val == null) {
                      return "Enter an non null email";
                    } else {
                      return val.isEmpty ? "Enter an email" : null;
                    }
                  },
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(76, 187, 155, 1),
                        width: 2,
                      ),
                    ),
                    labelText: 'Email address',
                    labelStyle: TextStyle(
                      color: _emailFocusNode.hasFocus
                          ? const Color.fromRGBO(76, 187, 155, 1)
                          : Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  focusNode: _passwordFocusNode,
                  onTap: _requestPasswordFocus,
                  validator: (val) {
                    if (val == null) {
                      return "Enter a non null password of minimum 6 chars";
                    } else {
                      return val.length < 6
                          ? "Enter a password of minimum 6 chars"
                          : null;
                    }
                  },
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(76, 187, 155, 1),
                        width: 2,
                      ),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: _passwordFocusNode.hasFocus
                          ? const Color.fromRGBO(76, 187, 155, 1)
                          : Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Phone Number (Optional)',
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: DropdownButton(
                        value: _selectedCountryCode,
                        items: _countryCodes.map((countryCode) {
                          return DropdownMenuItem(
                            value: countryCode,
                            child: Text(countryCode),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCountryCode = value.toString();
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: _phoneFocusNode,
                        onTap: _requestphoneFocus,
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(76, 187, 155, 1),
                              width: 2,
                            ),
                          ),
                          labelText: 'phone number',
                          labelStyle: TextStyle(
                            color: _phoneFocusNode.hasFocus
                                ? const Color.fromRGBO(76, 187, 155, 1)
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        if (_formkey.currentState!.validate()) {
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text);
                          if (result == null) {
                            setState(() {
                              error = 'Enter a valid email';
                            });
                          } else {
                            Navigator.pop(context);
                            print(result.uid);
                            await _db.CreateUser(
                                result.uid,
                                _emailController.text,
                               
                                _fullNameController.text,
                                // _phoneController.text,
                                // _selectedCountryCode
                                );
                            setState(() {
                              error = '';
                            });
                          }
                        }
                        // Successfully signed up user, do something here...

                        Navigator.of(_context).pushNamed('/homepage');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      backgroundColor: Color.fromRGBO(76, 187, 155, 1),
                      minimumSize: Size(100, 45),
                    ),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
