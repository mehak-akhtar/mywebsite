import 'package:flutter/material.dart';
import 'category_screen.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController nameController = TextEditingController();

  void goNext() {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter your name"),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CategoryScreen(userName: nameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAD7C3), Color(0xFFA65BA6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter your name",
                filled: true,
                fillColor: Colors.white,
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: goNext,
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}