import 'package:flutter/material.dart';

appBar(String title, {bool showBack = true, List<Widget>? actions}) {
  return AppBar(
    brightness: Brightness.light,
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.white,
    leading: showBack ? const BackButton(color: Colors.black,) : null,
    actions: actions,
    title: Text(
      title,
      style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.bold
      ),
    ),
  );
}