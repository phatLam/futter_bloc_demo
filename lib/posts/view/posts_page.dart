import 'package:demo2/posts/bloc/post_bloc.dart';
import 'package:demo2/posts/view/posts_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: BlocProvider(
          //we add a PostFetched() event so that when app loads, it request the
          //initial batch of Posts
          create: (_) => PostBloc(httpClient: http.Client())..add(PostFetched()),
          child: const PostsList(),
        ),
      );

  }
}
