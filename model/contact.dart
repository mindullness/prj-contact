import 'package:flutter_projects/prj-contact/enum/app_const.dart';

class Contact {
  int id;
  String contactName;
  String contactPhone;
  Contact(
      {required this.id,
      required this.contactName,
      required this.contactPhone});

  Map<String, dynamic> toMap() {
    return {
      AppConst.contactName: contactName,
      AppConst.contactPhone: contactPhone
    };
  }

  factory Contact.fromJson(Map<String, dynamic> map) {
    return Contact(
        id: map[AppConst.contactId],
        contactName: map[AppConst.contactName],
        contactPhone: map[AppConst.contactPhone]);
  }
}
