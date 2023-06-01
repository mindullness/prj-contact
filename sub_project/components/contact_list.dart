import 'package:flutter/material.dart';
import 'package:pretest_prj/components/contact_item.dart';
import 'package:pretest_prj/model/contact.dart';
import 'package:pretest_prj/page/contact_man.dart';

class ContactList extends StatelessWidget {
  final List<Contact> contacts;
  final void Function(Contact contact) onRemoveContact;
  const ContactList({
    super.key,
    required this.contacts,
    required this.onRemoveContact,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(contacts[index].id.toString()),
        background: Container(
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(children: const [
              Icon(Icons.edit, color: Colors.white),
              SizedBox(
                width: 8.0,
              ),
              Text('Update', style: TextStyle(color: Colors.white)),
            ]),
          ),
        ),
        secondaryBackground: Container(
          color: Theme.of(context)
              .colorScheme
              .secondaryContainer
              .withOpacity(0.75),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(children: const [
              Spacer(),
              Icon(Icons.delete, color: Colors.pink),
              SizedBox(
                width: 8.0,
              ),
              Text('Delete',
                  style: TextStyle(color: Color.fromARGB(255, 60, 76, 85))),
            ]),
          ),
        ),
        child: ContactItem(contact: contacts[index]),
        confirmDismiss: (direction) async {
          bool isUpdate = direction == DismissDirection.startToEnd;
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm"),
                content: isUpdate
                    ? const Text(
                        'Are you want to update this contact information?')
                    : const Text(
                        "Are you sure you wish to delete this contact?"),
                actions: <Widget>[
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: isUpdate
                          ? const Text("UPDATE")
                          : const Text('DELETE')),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("CANCEL"),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) async {
          bool isUpdate = direction == DismissDirection.startToEnd;
          if (isUpdate) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ContactManagement(
                  contacts[index],
                  isNew: false,
                ),
              ),
            );
          } else {
            onRemoveContact(contacts[index]);
          }
        },
      ),
    );
  }
}
