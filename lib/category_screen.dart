import 'dart:ui';
import 'package:flutter/material.dart';
import 'description_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String userName;

  const CategoryScreen({super.key, required this.userName});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool showAppOptions = false;
  bool showUniOptions = false;

  Widget categoryButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () {
          // 🔹 Application dropdown
          if (title == 'Application') {
            setState(() {
              showAppOptions = !showAppOptions;
              showUniOptions = false;
            });
            return;
          }

          // 🔹 University dropdown
          if (title == 'University Projects') {
            setState(() {
              showUniOptions = !showUniOptions;
              showAppOptions = false;
            });
            return;
          }

          // 🔹 Other categories → direct description
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DescriptionScreen(
                category: title,
                userName: widget.userName,
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
            ],
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 1.1),
            ),
          ),
        ),
      ),
    );
  }

  Widget optionChip(String title, String category) {
    return ChoiceChip(
      // ✨ Changed text to bold dark purple
      label: Text(
          title,
          style: TextStyle(
            color: Colors.purple.shade900,
            fontWeight: FontWeight.bold,
          )
      ),
      selected: false,
      // ✨ Changed background to bright frosted white so the dark text pops
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.purpleAccent.withOpacity(0.8), width: 1.5),
      ),
      onSelected: (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DescriptionScreen(
              category: category,
              userName: widget.userName,
            ),
          ),
        );
      },
    );
  }

  Widget universityChip(String title) {
    return ChoiceChip(
      // ✨ Changed text to bold dark purple
      label: Text(
          title,
          style: TextStyle(
            color: Colors.purple.shade900,
            fontWeight: FontWeight.bold,
          )
      ),
      selected: false,
      // ✨ Changed background to bright frosted white so the dark text pops
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.purpleAccent.withOpacity(0.8), width: 1.5),
      ),
      onSelected: (_) {
        if (title == 'Final Year Project') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("❌ Sorry, we do not make final year projects."),
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
            builder: (context) => DescriptionScreen(
              category: 'Semester Project',
              userName: widget.userName,
            ),
          ),
        );
      },
    );
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purpleAccent.withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(color: Colors.purpleAccent.withOpacity(0.5), blurRadius: 20, spreadRadius: 2),
                      ],
                    ),
                    child: const Icon(Icons.design_services_rounded, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Choose What You Need:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 25),

                  categoryButton('Canva Poster'),
                  categoryButton('Logo'),
                  categoryButton('Website'),
                  categoryButton('Portfolio'),
                  categoryButton('College Projects'),
                  categoryButton('Application'),


                  // 🔹 Application options
                  if (showAppOptions) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: [
                        optionChip('Web App', 'Web App'),
                        optionChip('Flutter App', 'Flutter App'),
                        optionChip('Native Kotlin App', 'Native Kotlin'),
                        optionChip('Native Java App', 'Native Java'),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],

                  categoryButton('University Projects'),

                  // 🔹 University options
                  if (showUniOptions) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: [
                        universityChip('Semester Project'),
                        universityChip('Final Year Project'),
                      ],
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}