import 'package:flutter/material.dart';
import 'package:flutter_projects/prj-contact/contact_list.dart';

class ContactHome extends StatelessWidget {
  const ContactHome({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
            title: const Text('All Contacts'),
            centerTitle: true,
            actions: const [
              AddContactButton(),
            ]),
        body: const ContactsList(),
      ),
    );
  }
}

class AddContactButton extends StatelessWidget {
  const AddContactButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        // set the border
        border: Border.all(width: 10, color: Theme.of(context).primaryColor),
        // border radius
        borderRadius: BorderRadius.circular(4),
        // background color
        color: Colors.indigo,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/cm');
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Icon(
            Icons.add,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
