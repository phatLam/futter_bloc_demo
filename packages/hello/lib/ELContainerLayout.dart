import 'dart:developer';

import 'package:flutter/material.dart';

class ELContainerLayout extends StatefulWidget {
  const ELContainerLayout({
    super.key,
    required this.toolbarWidget,
    required this.stickyWidget,
    required this.bodyWidget,
  });

  final Widget toolbarWidget;
  final Widget stickyWidget;
  final Widget bodyWidget;

  @override
  _ELContainerLayoutState createState() => _ELContainerLayoutState();
}

class _ELContainerLayoutState extends State<ELContainerLayout> {
  final GlobalKey _stickyKey = GlobalKey();
  double _stickyHeight = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log( 'Post frame callback');
      _getStickyHeight();
    });
  }

  void _getStickyHeight() {
    final RenderBox renderBox =
        _stickyKey.currentContext!.findRenderObject() as RenderBox;
    setState(() {
      _stickyHeight = renderBox.size.height;
      log('setState stickyHeight: $_stickyHeight');

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          log('setState stickyHeight: $_stickyHeight');
          return <Widget>[
            SliverToBoxAdapter(
              child: widget.toolbarWidget,
            ),
            SliverAppBar(
              toolbarHeight: _stickyHeight,
              floating: true,
              snap: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  key: _stickyKey,
                  child: widget.stickyWidget,
                ),
              ),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () async {
            // Add your refresh logic here
            await Future.delayed(const Duration(seconds: 2));
          },
          child: widget.bodyWidget,
        ),
      ),
    );
  }
}
