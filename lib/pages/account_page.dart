import 'package:cinereview/components/nav_bar.dart';
import 'package:cinereview/styles/colors.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.background,
      body: const Column(
        children: [
          Center(
            child: Text('Favoritos'),
          )
        ],
      ),
      bottomNavigationBar: NavBar(context, 3),
    );
  }
}
