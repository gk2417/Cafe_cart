import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';

class Signup extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final UsernameControler = TextEditingController();
  final emailControler = TextEditingController();
  final passwordcontroller = TextEditingController();
  final phonenumbercontroller = TextEditingController();
  final confirampassword = TextEditingController();

 

  bool isEmpty(input) => input == null || input.trim().isEmpty;

  bool isTooLong(input) => input.trim().length > 20;

  Future<void> signUp1(BuildContext context) async {
    // Show loading spinner
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.brown),
      ),
    );

    try {
      UserCredential userCred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailControler.text.trim(),
        password: passwordcontroller.text.trim(),
        
      );

      final phone = phonenumbercontroller.text.trim();
       final prefs = await SharedPreferences.getInstance();
                await prefs.setString('UserName', UsernameControler.text.trim());

      // Save user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user!.uid)
          .set({
        "UserName": UsernameControler.text.trim(),
        'email': emailControler.text.trim(),
        "password": passwordcontroller.text.trim(),
        'phone': phone,
        'created_at': Timestamp.now(),
      });

      Navigator.of(context).pop(); // Close loading dialog

      // Show success dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Signup successful!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 253, 235, 229),
      appBar: AppBar(
        title: const Text(
          "Welcome To Sign Up",
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 253, 235, 229),
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(key: _formKey,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/imagess.png",
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),

                        // Username
                        TextFormField(
                          controller: UsernameControler,
                          decoration: InputDecoration(
                            labelText: "Username",
                            prefixIcon: const Icon(Icons.person),
                            filled: true,
                            fillColor:
                                const Color.fromARGB(255, 253, 235, 229),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (isEmpty(value)) return "Username is empty";
                            if (isTooLong(value)) return "Username is too long";
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Email
                        TextFormField(
                          controller: emailControler,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon:
                                const Icon(Icons.mark_email_read_outlined),
                          ),
                          validator: (value) {
                            if (isEmpty(value)) return "Email is required";
                            if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                                .hasMatch(value!)) {
                              return "Invalid email ";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Phone Number
                        TextFormField(
                          controller: phonenumbercontroller,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.phone_android),
                          ),
                          validator: (value) {
                            if (isEmpty(value)) return "Phone is required";
                            if (!RegExp(r"^[0-9]{10}$").hasMatch(value!)) {
                              return "Enter valid 10-digit phone number";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Password
                        TextFormField(
                          controller: passwordcontroller,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: const Icon(Icons.visibility_off),
                          ),
                          validator: (value) {
                            if (isEmpty(value)) return "Password is required";
                            if (value!.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Confirm Password
                        TextFormField(
                          controller: confirampassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon:
                                const Icon(Icons.lock_outline_rounded),
                            suffixIcon: const Icon(Icons.visibility_off),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Confirm your password";
                            }
                            if (value.trim() !=
                                passwordcontroller.text.trim()) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 30),

                        // Signup Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: const Color.fromARGB(255, 75, 53, 45),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                signUp1(context);
                              }
                            },
                            child: const Text(
                              "Signup",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Login Redirect
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("I have an account?",
                                style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            GestureDetector(
                              
                              onTap: () {
                                 globals.loggedInEmail =UsernameControler.text.trim();
                                  globals.loggedInEmail =emailControler.text.trim();
                                Navigator.push(
                                  
                                  context,

                                  MaterialPageRoute(
                                     
                                      builder: (context) => LoginPage()),
                                );
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
