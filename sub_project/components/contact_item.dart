import 'package:flutter/material.dart';
import 'package:pretest_prj/model/contact.dart';

class ContactItem extends StatelessWidget {
  const ContactItem({super.key, required this.contact});
  final Contact contact;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.person_rounded),
          Text(contact.name, style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          const Icon(Icons.phone_iphone),
          Text(contact.phone, style: Theme.of(context).textTheme.titleMedium),
        ]),
      ),
    );
  }
}
