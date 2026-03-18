import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/dice_widget.dart';

class DiceScreen extends StatefulWidget {
  const DiceScreen({super.key});

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen>
    with SingleTickerProviderStateMixin {
  int diceNumber = 1;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  void rollDice() {
    final random = Random();
    _controller.forward(from: 0);
    setState(() {
      diceNumber = random.nextInt(6) + 1;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _scaleAnimation =
        Tween<double>(begin: 1, end: 1.3).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));

    _rotationAnimation =
        Tween<double>(begin: 0, end: 2 * pi).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
  Widget glowButton(Size size) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.8, end: 1.1),
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: GestureDetector(
        onTap: rollDice,
        child: Container(
          width: size.width * 0.65,
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.02,
          ),
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(50),
            gradient: const LinearGradient(
              colors: [
                Color(0xff57045a),
                Color(0xFFD4ACEF),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purpleAccent.withOpacity(0.7),
                blurRadius: 25,
                spreadRadius: 3,
              )
            ],
          ),
          child: Center(
            child: Text(
              "ROLL NOW",
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }Widget animatedDice(Size size) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF1F5F9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 15,
              offset: const Offset(-6, -6),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size.width * 0.35,
              height: size.width * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            DiceWidget(diceNumber: diceNumber),
          ],
        ),
      ),
    );
  }
  Widget header(Size size) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFF6D41F4),
              Color(0xFFB624F4),
              Color(0xFFA311F4),
            ],
          ).createShader(bounds),
          child: Text(
            "DICE ROLLER",
            style: TextStyle(
              fontSize: size.width * 0.085,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.015),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.012,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white.withOpacity(0.08),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Text(
            "Tap to roll and test your luck 🎲",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.width * 0.035,
              color: Colors.white.withOpacity(0.85),
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget statsCard(Size size) {
    return glassCard(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF00F5A0),
                  Color(0xFF00D9F5),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.6),
                  blurRadius: 20,
                )
              ],
            ),
            child: Icon(
              Icons.casino,
              size: size.width * 0.07,
              color: Colors.black,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          Text(
            "CURRENT VALUE",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: size.width * 0.035,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFFFFD700),
                Color(0xFFFFA500),
                Color(0xFFFF6A00),
              ],
            ).createShader(bounds),
            child: Text(
              "$diceNumber",
              style: TextStyle(
                fontSize: size.width * 0.12,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget background() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF141E30),
            Color(0xFF243B55),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
  Widget floatingCircles(Size size) {
    return Stack(
      children: [
        animatedBubble(
          size: 220,
          top: size.height * 0.05,
          left: size.width * 0.1,
          colors: [Color(0xFF00F5A0), Color(0xFF00D9F5)],
          duration: 6,
        ),
        animatedBubble(
          size: 160,
          bottom: size.height * 0.15,
          right: size.width * 0.05,
          colors: [Color(0xFFFC466B), Color(0xFF3F5EFB)],
          duration: 8,
        ),
        animatedBubble(
          size: 120,
          top: size.height * 0.3,
          right: size.width * 0.2,
          colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
          duration: 7,
        ),
        animatedBubble(
          size: 260,
          bottom: size.height * 0.05,
          left: size.width * 0.05,
          colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
          duration: 10,
        ),
        animatedBubble(
          size: 260,
          top: size.height * 0,
          right: size.width * 0.00,
          colors: [Color(0xFF0A9E75), Color(0xFF6213EA)],
          duration: 10,
        ),
      ],
    );
  }
  Widget animatedBubble({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required List<Color> colors,
    required int duration,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: -10, end: 10),
        duration: Duration(seconds: duration),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, value),
            child: child,
          );
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: colors,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.first.withOpacity(0.4),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget circle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.05),
      ),
    );
  }

  Widget footer(Size size) {
    return Column(
      children: [
        SizedBox(height: size.height * 0.03),
        Text(
          "Aditya kumar",
          style: TextStyle(
            color: Colors.white54,
            fontSize: size.width * 0.03,

          ),
        )
      ],
    );
  }
  Widget particles(Size size) {
    return Stack(
      children: List.generate(20, (index) {
        final random = Random(index);
        return Positioned(
          top: random.nextDouble() * size.height,
          left: random.nextDouble() * size.width,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(seconds: 3 + random.nextInt(5)),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: value,
                  child: child,
                ),
              );
            },
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 10,
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
  Widget animatedBackground() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 10),
      curve: Curves.linear,
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [
                Color(0xFF0F2027),
                Color(0xFF203A43),
                Color(0xFF2C5364),
              ],
              begin: Alignment(-1 + value, -1),
              end: Alignment(1 - value, 1),
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          animatedBackground(),
          particles(size),
          floatingCircles(size),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  header(size),
                  statsCard(size),
                  animatedDice(size),
                  glowButton(size),
                  footer(size),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}