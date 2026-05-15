import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

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

class _EmailScreenState extends State<EmailScreen> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  // Animation controller for the breathing glow effect on the button
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    // Setup the breathing glow animation
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 8.0, end: 25.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  Future<void> sendNotificationEmailToMe() async {
    // TODO: Replace with your actual Gmail and Google App Password (NO SPACES!)
    String myEmail ='unknownperson1814@gmail.com';
    String myAppPassword = 'fuhrdwxaevsnjuyy';

    final smtpServer = gmail(myEmail, myAppPassword);

    final message = Message()
      ..from = Address(myEmail, 'Smart Dev App')
      ..recipients.add(myEmail)
      ..subject = 'New Request: ${widget.category} from ${widget.userName}'
      ..text = '''
You have a new project request!

Name: ${widget.userName}
Contact Info: ${emailController.text.trim()}
Category: ${widget.category}

Description: 
${widget.description}
      ''';

    try {
      await send(message, smtpServer);
      print("EMAIL SUCCESS: Notification sent to admin");
    } catch (e) {
      print("EMAIL ERROR: Failed to send email to admin: $e");
    }
  }

  Future<void> submitRequest() async {
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("✨ Please enter an email or phone number!"),
          backgroundColor: Colors.purpleAccent.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // 1. Save to Firebase
      await FirebaseFirestore.instance.collection("requests").add({
        "name": widget.userName,
        "contact": emailController.text.trim(),
        "category": widget.category,
        "description": widget.description,
        "status": "waiting",
        "time": FieldValue.serverTimestamp(),
      });

      // 2. Send the Email
      await sendNotificationEmailToMe();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("🚀 Request sent successfully!"),
          backgroundColor: Colors.greenAccent.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );

      emailController.clear();

      // 3. Go back to the first screen
      Navigator.popUntil(context, (route) => route.isFirst);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Error submitting request"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
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
            colors: [Color(0xFF2A0845), Color(0xFF6441A5)], // Deep aesthetic purple gradient
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
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Frosted glass blur
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1), // Semi-transparent card
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2), // Light glowing border
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 30,
                          spreadRadius: 10,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Aesthetic Icon
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purpleAccent.withOpacity(0.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purpleAccent.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.mark_email_unread_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 25),

                        const Text(
                          "Let's Stay in Touch",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Enter your email or phone number so we can get back to you.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 35),

                        // Glowing Text Field
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purpleAccent.withOpacity(0.2),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.purpleAccent,
                            decoration: InputDecoration(
                              hintText: "Email or Phone...",
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.15), // Glass text field
                              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(color: Colors.purpleAccent, width: 2),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Animated Glowing Button
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
                                    blurRadius: _glowAnimation.value, // Pulses in and out!
                                    spreadRadius: _glowAnimation.value / 4,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: isLoading ? null : submitRequest,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.purple.shade900,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                                  ),
                                )
                                    : const Text(
                                  "Send Request",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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