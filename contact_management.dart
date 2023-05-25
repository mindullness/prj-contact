import 'package:flutter/material.dart';
import 'package:flutter_projects/prj-contact/db/db_repository.dart';
import 'package:flutter_projects/prj-contact/model/contact.dart';

class ContactManagement extends StatefulWidget {
  const ContactManagement({super.key});

  @override
  State<ContactManagement> createState() => _ContactManagementState();
}

class _ContactManagementState extends State<ContactManagement> {
  final TextEditingController _txtContactName = TextEditingController();
  final TextEditingController _txtContactPhone = TextEditingController();
  String errorText = '';
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Management'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white70,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            Visibility(
              visible: false,
              child: Text(errorText),
            ),
            TextField(
              autofocus: true,
              controller: _txtContactName,
              decoration: const InputDecoration(hintText: 'Enter name...'),
            ),
            TextField(
              controller: _txtContactPhone,
              decoration: const InputDecoration(hintText: 'Enter phone...'),
            ),
            const SizedBox(height: 10),
            FilledButton(
              style: const ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.indigo),
              ),
              onPressed: () async {
                final db = DBRepository.instance;
                final id = await db.insert(
                    model: Contact(
                        id: 0,
                        contactName: _txtContactName.text,
                        contactPhone: _txtContactPhone.text));
                if (id != 0) {
                  if (!context.mounted) return;
                  addContactSuccess(context);
                } else {
                  setState(() {
                    errorText = "Wrong";
                    isError = true;
                  });
                }
              },
              child: const Text(
                'Create',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ]
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: e,
                  ))
              .toList(),
        ),
      ),
    );
  }

  void addContactSuccess(BuildContext context) {
    _txtContactName.clear();
    _txtContactPhone.clear();
    Navigator.of(context).popAndPushNamed('/');
    // Navigator.pushNamed(context, '/');
    isError = false;
  }
}
