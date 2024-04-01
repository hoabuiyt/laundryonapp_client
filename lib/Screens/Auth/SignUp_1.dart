import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:laundryonapp/API_calls/auth_service.dart';
import 'package:laundryonapp/Models/authData.dart';
import 'package:laundryonapp/Provider/authData_provider.dart';

import 'package:laundryonapp/Screens/Auth/SignUp_2.dart';

class SignUpScreen_1 extends ConsumerStatefulWidget {
  const SignUpScreen_1({super.key});

  @override
  ConsumerState<SignUpScreen_1> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen_1> {
  final GlobalKey<FormState> _loginformKey = GlobalKey<FormState>();
  var _enteredFirstName = '';
  var _enteredLastName = '';

  _nextPage() {
    if (_loginformKey.currentState!.validate()) {
      _loginformKey.currentState!.save();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SignUpScreen_2(
              firstName: _enteredFirstName, lastName: _enteredLastName),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Color(0xFFD7F0FF)),
                    height: screenHeight * 0.45,
                  ),
                  Positioned(
                    width: 154,
                    right: 0,
                    top: 32,
                    child: Image.asset(
                      'assets/bubbles.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/laundryonapp_logo.svg'),
                  const SizedBox(
                    height: 22,
                  ),
                  Text(
                    'Register',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF1C2649),
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Text(
                    'Create a new account',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF1C2649),
                    ),
                  ),
                  const Gap(64),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE5E5E5),
                            width: 1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(25, 0, 0, 0),
                              blurRadius: 25,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 32),
                          child: Form(
                            key: _loginformKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'First Name',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF1C2649),
                                  ),
                                ),
                                const Gap(8),
                                Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                16, 16, 16, 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE5E5E5),
                                            width: 1,
                                          ),
                                        ),
                                        hintText: "John",
                                        hintStyle: GoogleFonts.poppins(
                                          color: const Color(0xFF6A6C71),
                                        ),
                                      ),
                                      textInputAction: TextInputAction.next,
                                      autocorrect: false,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().length <= 1) {
                                          return 'Please enter a valid First Name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredFirstName = value!;
                                      },
                                    ),
                                  ],
                                ),
                                const Gap(24),
                                Text(
                                  'Last Name',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF1C2649),
                                  ),
                                ),
                                const Gap(8),
                                Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                16, 16, 16, 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE5E5E5),
                                            width: 1,
                                          ),
                                        ),
                                        hintText: "Doe",
                                        hintStyle: GoogleFonts.poppins(
                                          color: const Color(0xFF6A6C71),
                                        ),
                                      ),
                                      autocorrect: false,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().length <= 1) {
                                          return 'Please enter a valid Last Name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _enteredLastName = value!;
                                      },
                                      onFieldSubmitted: (value) {
                                        _nextPage();
                                      },
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ],
                                ),
                                const Gap(24),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4C95EF),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  onPressed: _nextPage,
                                  child: Text(
                                    'Next',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: const Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                                const Gap(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account?',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: const Color(0xFF6A6C71),
                                      ),
                                    ),
                                    const Gap(3),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(0.0),
                                          minimumSize: const Size(0, 0),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap),
                                      onPressed: () {},
                                      child: Text(
                                        'Login',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: const Color(0xFF409CFF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
