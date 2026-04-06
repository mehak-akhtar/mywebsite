import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailScreen extends StatefulWidget {
  final String category;
  final String description;
  final String userName;

  const EmailScreen({
    super.key,
    required this.category,
    required this.description,
    required this.userName,
  });

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  Future<void> submitRequest() async {
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email or phone required"),
          backgroundColor: Colors.purple,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection("requests").add({
        "name": widget.userName,
        "contact": emailController.text.trim(),
        "category": widget.category,
        "description": widget.description,
        "status": "waiting",
        "time": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Request sent successfully"),
          backgroundColor: Colors.purple,
        ),
      );

      emailController.clear();

      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      print("FIRESTORE ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error submitting request"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAD7C3), Color(0xFFA65BA6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter your Email or Phone",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter email or phone",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: 180,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF123B5A),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}