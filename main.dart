import 'package:flutter/material.dart';
import 'package:flutter_projects/prj-contact/contact_home.dart';
import 'package:flutter_projects/prj-contact/contact_management.dart';

void main() {
  runApp(const ContactApp());
}

class ContactApp extends StatelessWidget {
  const ContactApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.grey),
      initialRoute: '/',
      routes: {
        '/': (context) => const ContactHome(),
        '/cm': (context) => const ContactManagement(),
      },
    );
  }
}
