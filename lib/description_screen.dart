import 'package:flutter/material.dart';
import 'email_screen.dart';

class DescriptionScreen extends StatefulWidget {
  final String category;
  final String userName;

  const DescriptionScreen({
    super.key,
    required this.category,
    required this.userName,
  });

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  final TextEditingController descriptionController = TextEditingController();

  int currentCount = 0;
  final int maxLimit = 2000;

  @override
  void initState() {
    super.initState();

    descriptionController.addListener(() {
      setState(() {
        currentCount = descriptionController.text.length;
      });
    });
  }

  void goToEmail() {
    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Description cannot be empty"),
          backgroundColor: Colors.purple,
        ),
      );
      return;
    }

    if (currentCount > maxLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Limit exceeded"),
          backgroundColor: Colors.purple,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailScreen(
          category: widget.category,
          description: descriptionController.text,
          userName: widget.userName,
        ),
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
            Text(
              "Category: ${widget.category}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: descriptionController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Enter description",
                filled: true,
                fillColor: Colors.white,
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: Text("$currentCount/$maxLimit"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: goToEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF123B5A),
              ),
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}