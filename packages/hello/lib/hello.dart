library hello;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hello/ELContainerLayout.dart';

class Hello extends StatefulWidget {
  const Hello({super.key});

  @override
  State<Hello> createState() => _HelloState();
}

class _HelloState extends State<Hello> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ELContainerLayout(
      toolbarWidget: ELToolbarWidget(),
      stickyWidget: ELStickyWidget(),
      bodyWidget: ELBodyWidget(),
    ));
  }
}

class ELBodyWidget extends StatelessWidget {
  const ELBodyWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Item $index'),
        );
      },
    );
  }
}

class ELStickyWidget extends StatelessWidget {
  const ELStickyWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.yellow,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sticky Widget',
              style: TextStyle(
                color: Color.fromARGB(255, 170, 35, 35),
                fontSize: 24,
              ),
            ),
            const Text(
              'Sticky Widget',
              style: TextStyle(
                color: Color.fromARGB(255, 170, 35, 35),
                fontSize: 24,
              ),
            ),
            const Text(
              'Sticky Widget',
              style: TextStyle(
                color: Color.fromARGB(255, 170, 35, 35),
                fontSize: 24,
              ),
            ),
            const Text(
              'Sticky Widget',
              style: TextStyle(
                color: Color.fromARGB(255, 170, 35, 35),
                fontSize: 24,
              ),
            ),
            const Text(
              'Sticky Widget',
              style: TextStyle(
                color: Color.fromARGB(255, 170, 35, 35),
                fontSize: 24,
              ),
            ),
          ],
        ),
      );
  }
}

class ELToolbarWidget extends StatelessWidget {
  const ELToolbarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Column(
          children: [
            const Text(
              "AppLocalizations.of(context).helloWorld",
              style: TextStyle(
                color: Color.fromARGB(255, 217, 53, 53),
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
