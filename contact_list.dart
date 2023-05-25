import 'package:flutter/material.dart';
import 'package:flutter_projects/prj-contact/db/db_repository.dart';
import 'package:flutter_projects/prj-contact/model/contact.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  late TextEditingController _txtSearch = TextEditingController();
  String searchText = '';
  List<Contact> _contacts = [];

  void _initDb() async {
    await DBRepository.instance.getDb;
  }

  void _refreshState() async {
    setState(() {});
    await DBRepository.instance
        .getAllContacts()
        .then((value) => {setState(() => _contacts = value)});
  }

  @override
  void initState() {
    _initDb();
    _refreshState();
    _txtSearch = TextEditingController(text: searchText);
    super.initState();
  }

  @override
  void dispose() {
    _txtSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        child: TextField(
          autofocus: false,
          controller: _txtSearch,
          onEditingComplete: () => setState(() {
            searchText = _txtSearch.text;
          }),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      Expanded(
        child: _showContact(),
      ),
    ]);
  }

  _showContact() {
    return ListView(
      children: _getListView(searchText),
    );
  }

  List<Widget> _getListView(String search) {
    List<Widget> body = _contacts
        .where(
            (e) => e.contactName.toLowerCase().contains(search.toLowerCase()))
        .map((e) => _getSingleContact(e))
        .toList();
    return body;
  }

  Dismissible _getSingleContact(Contact e) {
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
            if (await _handleUpdate()) {}
          } else {
            await _handleDelete(e.id).then((value) {
              value
                  ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                      children: [
                        const Icon(
                          Icons.done_rounded,
                          color: Colors.green,
                        ),
                        Text('Deleted person $deleteName'),
                      ],
                    )))
                  : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                      children: [
                        const Icon(
                          Icons.dangerous_outlined,
                          color: Colors.red,
                        ),
                        Text('Cannot delete person $deleteName'),
                      ],
                    )));
            });
          }
        },
        child: ListTile(
            leading: const Icon(Icons.person),
            title: Text(e.contactName),
            subtitle: Text(e.contactPhone)));
  }

  Future<bool> _handleDelete(int id) async =>
      await DBRepository.instance.deleteContact(id).then((value) {
        _contacts.removeWhere((e) => e.id == id);
        _refreshState();
        return value;
      }).catchError((err) async {
        return false;
      });

  Future<bool> _handleUpdate() async {
    return true;
  }
}
