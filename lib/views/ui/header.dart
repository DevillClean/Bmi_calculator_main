import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            context.go('/Settings');
          },
          icon: const Icon(
            Icons.menu,
            size: 30,
          ),
        ),
        const Text('BMI CALCULATOR'),
      ],
    );
  }
}
