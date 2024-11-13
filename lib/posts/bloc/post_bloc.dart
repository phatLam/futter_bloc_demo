import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../models/post.dart';

part 'post_event.dart';

part 'post_state.dart';

const _postLimit = 20;
const throttleDuration = Duration(microseconds: 100);

/// Used to change how events are processed. By default events are processed concurrently.
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required this.httpClient}) : super(const PostState()) {
    on<PostFetched>(_onFetched,
        transformer: throttleDroppable(throttleDuration));
  }

  final http.Client httpClient;

  FutureOr<void> _onFetched(PostFetched event, Emitter<PostState> emit) async {
    if (state.hasReachMax) {
      return;
    }
    try {
      print("offset = ${state.posts.length}");
      final posts = await _fetchPosts(startIndex: state.posts.length);
      if (posts.isEmpty) {
        return emit(state.copyWith(hasReachMax: true));
      }
      final list = [...state.posts, ...posts];
      print("new size = ${list.length}");
      emit(state.copyWith(
          posts: list, status: PostStatus.success));
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<List<Post>> _fetchPosts({required int startIndex}) async {
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Post(
          id: map['id'] as int,
          title: map['title'] as String,
          body: map['body'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}
