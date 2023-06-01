import 'package:pretest_prj/constant/const_contact.dart';

class Contact {
  int id;
  String name;
  String phone;
  Contact({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
        id: map[ConstContact.id],
        name: map[ConstContact.name],
        phone: map[ConstContact.phone]);
  }
  Map<String, dynamic> toMap() {
    return {
      ConstContact.name: name,
      ConstContact.phone: phone,
    };
  }
}
