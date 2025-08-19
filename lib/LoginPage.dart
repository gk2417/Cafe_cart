import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Bottombar.dart';
import 'Signup.dart';
import 'globals.dart' as globals;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _checkLoggedInUser();

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _animationController.forward();
  }

Future<void> _checkLoggedInUser() async {
  bool connected = await _hasInternet();
  if (!connected) {
    _showNoInternetPopup();
    return;
  }

  // Step 2: Check Firebase login status
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Bottombar()),
    );
  } else {
    _showErrorMessage("No user found. Please log in.");
  }
}

/// Check internet connection
Future<bool> _hasInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException {
    return false;
  }
}

/// Show popup with "Try Again" until internet comes back
void _showNoInternetPopup() {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.all(16),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✅ Use a JSON Lottie file, not JPG
                Lottie.asset(
                  'assets/com.json',
                  height: 120,
                  repeat: true,
                  fit: BoxFit.contain,
                  delegates: LottieDelegates(
                    values: [
                      // If JSON has some issues, Lottie will still try to render
                     
                    ],
                  ),
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if JSON is corrupted
                    return const Icon(Icons.wifi_off, size: 80, color: Colors.red);
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  "No internet connection.\nPlease connect to continue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    bool connected = await _hasInternet();
                    if (connected) {
                      Navigator.of(context, rootNavigator: true).pop(); // ✅ Close dialog
                      Future.delayed(const Duration(milliseconds: 100), () {
                        _checkLoggedInUser(); // ✅ Retry login
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Try Again"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


/// General error popup
void _showErrorMessage(String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/com.json',
            height: 100,
            repeat: false,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("OK"),
          ),
        ],
      ),
    ),
  );
}

  Future<void> login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      UserCredential userCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', emailController.text.trim());

      final uid = userCred.user!.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        setState(() => isLoading = false);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Login Failed"),
            content: const Text("User record not found in Firestore."),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
          ),
        );
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 253, 235, 229),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/login2.json',
                    width: 170,
                    height: 170,
                    repeat: false,
                    onLoaded: (composition) {
                      Future.delayed(composition.duration, () {
                        Navigator.pop(context);
                        globals.loggedInEmail = emailController.text.trim();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => Bottombar()),
                          (route) => false,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Logging in...",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.brown),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Login Error"),
          content: Text(e.message ?? "Something went wrong"),
          actions: [TextButton(child: const Text("OK"), onPressed: () => Navigator.pop(context))],
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 235, 229),
      appBar: AppBar(
        title: Text(
          "Welcome to login!",
          style: GoogleFonts.anta(color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 253, 235, 229),
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            Image.asset("assets/image2.png", height: 180),
                            const SizedBox(height: 80),

                            // Email Field
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                prefixIcon: const Icon(Icons.mark_email_read_outlined),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Enter an email";
                                if (!value.contains('@')) return "Invalid email";
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Password Field
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: const Icon(Icons.visibility_off),
                              ),
                              validator: (value) => (value == null || value.isEmpty) ? "Enter a password" : null,
                            ),
                            const SizedBox(height: 60),

                            // Social Icons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (var img in [
                                  "assets/image12.png",
                                  "assets/Facebook.png",
                                  "assets/images13.jpeg",
                                  "assets/twitter.png"
                                ])
                                  CircleAvatar(radius: 25, backgroundImage: AssetImage(img)),
                              ],
                            ),

                            const SizedBox(height: 100),

                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4B352D), // brown
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                ),
                                onPressed: isLoading ? null : () => login(context),
                                child: isLoading
                                    ? const CircularProgressIndicator(color: Color(0xFFFDEBE5))
                                    : const Text("Login", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Sign Up Text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account?", style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Signup()),
                                    );
                                  },
                                  child: const Text(
                                    "Sign Up",
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
