import 'package:flutter/material.dart';

Widget addUserField(String label, TextEditingController ctrl, TextInputType type) {
  return Padding(
    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
    child: TextField(
      keyboardType: type,
      controller: ctrl,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black, width: 0.9),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.indigo, width: 2),
        ),
        labelText: label,
      ),
    ),
  );
}
