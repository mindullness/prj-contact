import 'package:flutter/material.dart';
import 'package:pretest_prj/model/contact.dart';
import 'package:pretest_prj/repository/contact.dart';

class ContactManagement extends StatefulWidget {
  final bool isNew;
  final Contact contact;
  const ContactManagement(this.contact, {super.key, required this.isNew});

  @override
  State<ContactManagement> createState() => _ContactManagementState();
}

class _ContactManagementState extends State<ContactManagement> {
  final _txtName = TextEditingController();
  final _txtPhone = TextEditingController();

  @override
  void initState() {
    if (!widget.isNew) {
      _txtName.text = widget.contact.name;
      _txtPhone.text = widget.contact.phone;
    }
    super.initState();
  }

  @override
  void dispose() {
    _txtName.dispose();
    _txtPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String btnText = widget.isNew ? 'Create' : 'Update';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Management'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Container(
          height: double.infinity,
          width: 300,
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            ContactText('name', _txtName),
            ContactText('phone', _txtPhone),
            ElevatedButton(
              style: const ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))))),
              onPressed: () async {
                widget.contact.name = _txtName.text;
                widget.contact.phone = _txtPhone.text;
                if (widget.isNew) {
                  print("Contact ID when insert: ${widget.contact.id}");
                  await ContactRepository.insert(widget.contact).then((value) {
                    handleThen(value, context, true);
                  }).catchError((err) {
                    handleCatch(context, err, true);
                  });
                } else {
                  //
                  await ContactRepository.update(widget.contact).then((value) {
                    handleThen(value, context, false);
                  }).catchError((err) {
                    handleCatch(context, err, false);
                  });
                }
              },
              child: Text(btnText),
            )
          ]),
        ),
      ),
    );
  }

  void handleCatch(BuildContext context, err, bool isNew) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
        Text('${isNew ? 'Add' : 'Update'} failed by ${err.toString()}'),
      ],
    )));
  }

  void handleThen(int value, BuildContext context, bool isNew) {
    if (value > 0) {
      Navigator.popAndPushNamed(context, '/');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
        children: [
          const Icon(
            Icons.done,
            color: Colors.green,
          ),
          Text('${isNew ? 'Add' : 'Update'} successfully!'),
        ],
      )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
          Text('${isNew ? 'Add' : 'Update'} failed!'),
        ],
      )));
    }
  }
}

class ContactText extends StatelessWidget {
  final String field;
  final TextEditingController controller;
  const ContactText(this.field, this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        maxLength: field == 'name' ? 50 : 15,
        controller: controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: 'Enter $field...'),
      ),
    );
  }
}
