import 'package:flutter/material.dart';
import 'package:pretest_prj/components/contact_list.dart';
import 'package:pretest_prj/model/contact.dart';
import 'package:pretest_prj/page/contact_man.dart';
import 'package:pretest_prj/repository/contact.dart';

class MainActivity extends StatefulWidget {
  const MainActivity({super.key});

  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  final TextEditingController _txtSearch = TextEditingController();
  late String searchText = '';

  late List<Contact> _contacts = [];

  @override
  void initState() {
    _refreshContacts();
    _txtSearch.text = searchText;
    super.initState();
  }

  @override
  void dispose() {
    _txtSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No contact found!'),
    );

    if (_contacts.isNotEmpty) {
      mainContent =
          ContactList(contacts: _contacts, onRemoveContact: _removeContact);
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).secondaryHeaderColor.withOpacity(0.9),
          foregroundColor: Colors.black87,
          title: const Text('All Contacts'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(13),
              child: SizedBox(
                height: 38,
                width: 68,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: IconButton(
                      iconSize: 16,
                      onPressed: () {
                        // showDialog(
                        //     context: context,
                        //     builder: (context) => ContactManagement(
                        //           Contact(id: 0, name: '', phone: ''),
                        //           isNew: true,
                        //         ));
                        Navigator.of(context).pop(true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactManagement(
                                Contact(id: 0, name: '', phone: ''),
                                isNew: true),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                    )),
              ),
            ),
          ],
        ),
        body: Column(children: [
          SizedBox(
            child: TextField(
              autofocus: false,
              controller: _txtSearch,
              onEditingComplete: () => {
                setState(() {
                  searchText = _txtSearch.text;
                  _refreshContacts();
                })
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(child: mainContent),
        ]),
      ),
    );
  }

  void _refreshContacts() async {
    setState(() {});
    await ContactRepository.getContacts(searchText)
        .then((value) => {setState(() => _contacts = value)});
  }

  Future<void> _removeContact(Contact contact) async {
    await ContactRepository.delete(contact.id).then((value) => {
          if (value)
            {
              // _contacts.remove(contact),
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(children: const [
                Icon(Icons.done, color: Colors.red),
                Text('Delete successfully!')
              ]))),
              _refreshContacts()
            }
          else
            {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(children: const [
                Icon(Icons.error_outline, color: Colors.red),
                Text('Delete failed', style: TextStyle(color: Colors.amber))
              ])))
            }
        });
  }
}
