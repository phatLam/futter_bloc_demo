library hello;

import 'package:flutter/material.dart';
import 'package:hello/l10n/app_localizations.dart';




class Hello extends StatefulWidget {
  const Hello({super.key});

  @override
  State<Hello> createState() => _HelloState();
}

class _HelloState extends State<Hello> {
  @override
  Widget build(BuildContext context) {
    return Text(AppLocalizations.of(context)!.hello);
  }
}
