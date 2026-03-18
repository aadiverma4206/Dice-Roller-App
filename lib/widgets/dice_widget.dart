import 'package:flutter/material.dart';

class DiceWidget extends StatelessWidget {
  final int diceNumber;

  const DiceWidget({super.key, required this.diceNumber});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Image.asset(
        'assets/images/dice_$diceNumber.png',
        key: ValueKey(diceNumber),
        width: size.width * 0.4,
      ),
    );
  }
}