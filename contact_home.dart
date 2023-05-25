import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_projects/prj-contact/db/db_repository.dart';
import 'package:flutter_projects/prj-contact/model/contact.dart';

class ContactHome extends StatefulWidget {
  const ContactHome({super.key});

  @override
  State<ContactHome> createState() => _ContactHomeState();
}

class _ContactHomeState extends State<ContactHome> {
  final TextEditingController _txtSearch = TextEditingController();
  String searchText = '';
  List<Contact> _contacts = [];

  void initDb() async {
    await DBRepository.instance.getDb;
  }

  void refreshState() async {
    await DBRepository.instance.getAllContacts().then((value) => {
          setState(() {
            _contacts = value;
          })
        });
  }

  @override
  void initState() {
    initDb();
    refreshState();
    super.initState();
  }

  @override
  void dispose() {
    _txtSearch.dispose();
    super.dispose();
  }

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
        body: Column(children: [
          SizedBox(
            child: TextField(
              autofocus: false,
              controller: _txtSearch,
              onEditingComplete: _search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: getListView(searchText),
            ),
          ),
        ]),
      ),
    );
  }

  List<Widget> getListView(String search) {
    List<Widget> body = _contacts
        .where(
            (e) => e.contactName.toLowerCase().contains(search.toLowerCase()))
        .map((e) {
      return Dismissible(
          key: UniqueKey(),
          background: Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: const [
                  Icon(Icons.edit, color: Colors.white),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text('Update', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(Icons.delete, color: Colors.white),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text('Delete', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
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
            String deleteName = e.contactName;
            if (isUpdate) {
              await _handleUpdate();
            } else {
              await _handleDelete(e.id, deleteName);
            }
          },
          child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(e.contactName),
              subtitle: Text(e.contactPhone)));
    }).toList();
    return body;
  }

  void _search() {
    setState(() {
      searchText = _txtSearch.text;
    });
    // return _showContact();
  }

  Future<void> _handleDelete(int id, String deleteName) async {
    bool deleted = await DBRepository.instance.deleteContact(id);
    if (deleted) {
      _contacts.removeWhere((e) => e.id == id);
      setState(() {});
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Deleted person $deleteName')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot delete person $deleteName')));
    }
  }

  Future<void> _handleUpdate() async {}
}

class AddContactButton extends StatelessWidget {
  const AddContactButton({
    super.key,
  });

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
