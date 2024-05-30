import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customAppBar(String text) {
  return AppBar(
    title: Text(
      text,
      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
    ),
  );
}

InputDecoration inputDecoration(String text) {
  return InputDecoration(
    isDense: true,
    labelText: text,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(15)),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1),
      borderRadius: BorderRadius.circular(15),
    ),
  );
}
