import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_application_1/LoginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        // ✅ Screen 1: Fullscreen Lottie with animated text
        PageViewModel(
          titleWidget: const SizedBox.shrink(), // Hides default title
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  TypewriterAnimatedText(
                    "Welcome to CoffeeTime",
                    textStyle: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                    speed: const Duration(milliseconds: 80),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  TypewriterAnimatedText(
                    "Start your day with the best brewed coffee.",
                    textAlign: TextAlign.center,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
          image: buildLottie("assets/screen1.json"),
          decoration: pageDecoration(lottie: true),
        ),

        // ✅ Screen 2: Animated title and body
        PageViewModel(
          titleWidget: AnimatedTextKit(
            isRepeatingAnimation: false,
            animatedTexts: [
              TypewriterAnimatedText(
                "Fast Delivery",
                textStyle: GoogleFonts.playfairDisplay(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade800,
                ),
                speed: const Duration(milliseconds: 80),
              ),
            ],
          ),
          bodyWidget: AnimatedTextKit(
            isRepeatingAnimation: false,
            animatedTexts: [
              TypewriterAnimatedText(
                "Fresh coffee delivered to your doorstep instantly.",
                textStyle: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          image: buildLottie("assets/screen2.json"),
          decoration: pageDecoration(lottie: true),
        ),

        // ✅ Screen 3: Animated title, body and button
        PageViewModel(
          titleWidget: AnimatedTextKit(
            isRepeatingAnimation: false,
            animatedTexts: [
              TypewriterAnimatedText(
                "Easy & Secure Payment",
                textStyle: GoogleFonts.playfairDisplay(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade800,
                ),
                speed: const Duration(milliseconds: 80),
              ),
            ],
          ),
          bodyWidget: AnimatedTextKit(
            isRepeatingAnimation: false,
            animatedTexts: [
              TypewriterAnimatedText(
                "Multiple payment options for a hassle-free experience.",
                textStyle: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          image: buildLottie("assets/screen3.json"),
          decoration: pageDecoration(),
        footer: Align(
  alignment: Alignment.center,
  child: TweenAnimationBuilder<double>(
    tween: Tween<double>(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 800),
    curve: Curves.easeOutBack,
    builder: (context, value, child) {
      return Transform.scale(
        scale: value,
        child: child,
      );
    },
    child: SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: () => goToLogin(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          "Get Started",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ),
  ),
),


        ),
      ],
      showSkipButton: true,
      skip: const Text("Skip", style: TextStyle(fontSize: 16)),
      next: const Icon(Icons.arrow_forward_ios),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () => goToLogin(context),
      onSkip: () => goToLogin(context),
      dotsDecorator: DotsDecorator(
        size: const Size(10, 10),
        activeSize: const Size(22, 10),
        activeColor: Colors.brown,
        color: Colors.grey.shade400,
        spacing: const EdgeInsets.symmetric(horizontal: 4),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      curve: Curves.fastOutSlowIn,
    );
  }

  // ✅ Lottie animation widget
  Widget buildLottie(String path) => SizedBox(
        width: double.infinity,
        height: 400,
        child: Lottie.asset(path, fit: BoxFit.contain),
      );

  // ✅ Page decoration method
  PageDecoration pageDecoration({bool lottie = false}) {
    return PageDecoration(
      titlePadding: const EdgeInsets.only(top: 0),
      imagePadding: lottie ? const EdgeInsets.only(top: 20) : const EdgeInsets.only(top: 0),
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.brown.shade800,
      ),
      bodyTextStyle: const TextStyle(fontSize: 16),
      contentMargin: const EdgeInsets.all(16),
      imageFlex: 3,
      bodyFlex: 2,
    );
  }

  void goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }
}
