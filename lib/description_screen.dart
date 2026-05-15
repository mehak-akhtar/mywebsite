import 'dart:ui';
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

class _DescriptionScreenState extends State<DescriptionScreen> with SingleTickerProviderStateMixin {
  final TextEditingController descriptionController = TextEditingController();

  int currentCount = 0;
  final int maxLimit = 2000;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    descriptionController.addListener(() {
      setState(() {
        currentCount = descriptionController.text.length;
      });
    });

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 8.0, end: 25.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  void goToEmail() {
    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("✨ Description cannot be empty"),
          backgroundColor: Colors.purpleAccent.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
      return;
    }

    if (currentCount > maxLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("❌ Limit exceeded"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
  void dispose() {
    descriptionController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2A0845), Color(0xFF6441A5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, spreadRadius: 10)
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purpleAccent.withOpacity(0.2),
                            boxShadow: [
                              BoxShadow(color: Colors.purpleAccent.withOpacity(0.5), blurRadius: 20, spreadRadius: 2),
                            ],
                          ),
                          child: const Icon(Icons.description_rounded, size: 50, color: Colors.white),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          widget.category,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Tell us about your project requirements.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                        ),
                        const SizedBox(height: 35),

                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.purpleAccent.withOpacity(0.2), blurRadius: 15, spreadRadius: 1),
                            ],
                          ),
                          child: TextField(
                            controller: descriptionController,
                            maxLines: 6,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.purpleAccent,
                            decoration: InputDecoration(
                              hintText: "Enter description...",
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.15),
                              contentPadding: const EdgeInsets.all(20),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Colors.purpleAccent, width: 2)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "$currentCount/$maxLimit",
                            style: TextStyle(
                              color: currentCount > maxLimit ? Colors.redAccent : Colors.white.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                        AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 200,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purpleAccent.withOpacity(0.6),
                                    blurRadius: _glowAnimation.value,
                                    spreadRadius: _glowAnimation.value / 4,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: goToEmail,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.purple.shade900,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  elevation: 0,
                                ),
                                child: const Text("Next", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}