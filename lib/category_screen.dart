
import'package:flutter/material.dart';
import'description_screen.dart';

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
height: 50,
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(30),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.1),
blurRadius: 8,
),
],
),
child: Center(
child: Text(
title,
style: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.w600,
color: Color(0xFF123B5A),
),
),
),
),
),
);
}

Widget optionChip(String title, String category) {
return ChoiceChip(
label: Text(title),
selected: false,
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
label: Text(title),
selected: false,
onSelected: (_) {
if (title == 'Final Year Project') {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content:
Text("❌ Sorry, we do not make final year projects."),
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
body: Container(
width: double.infinity,
height: double.infinity,
decoration: const BoxDecoration(
gradient: LinearGradient(
colors: [Color(0xFFEAD7C3), Color(0xFFA65BA6)],
begin: Alignment.topCenter,
end: Alignment.bottomCenter,
),
),
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 24),
child: SingleChildScrollView(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const SizedBox(height: 80),

const Text(
'Choose What you want us to create:',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 25),

categoryButton('Canva Poster'),
categoryButton('Logo'),
categoryButton('Website'),
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
],
),
),
),
),
);
}
}

