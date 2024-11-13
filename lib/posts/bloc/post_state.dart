part of 'post_bloc.dart';

enum PostStatus { initial, success, failure }

final class PostState extends Equatable {
  final PostStatus status;
  final List<Post> posts;
  final bool hasReachMax;

  const PostState(
      {this.status = PostStatus.initial,
      this.posts = const <Post>[],
      this.hasReachMax = false});

  /// We implemented copyWith so that we can copy
  /// an instance of PostSuccess and update zero or more properties conveniently (this will come in handy later).
  PostState copyWith(
      {PostStatus? status, List<Post>? posts, bool? hasReachMax}) {
    return PostState(
        status: status ?? this.status,
        posts: posts ?? this.posts,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [status, posts, hasReachMax];
}
