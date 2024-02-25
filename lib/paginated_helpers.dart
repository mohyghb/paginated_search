// Helpers to efficiently add pagination to your app

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paginated_search/paginated_search.dart';
import 'package:paginated_search/search_provider.dart';

typedef PaginatedSearchControllerProvider<T> = AutoDisposeNotifierProvider<PaginatedSearchController<T>, PaginatedState<T>>;

AutoDisposeNotifierProvider<PaginatedSearchController<T>, PaginatedState<T>> createPaginatedController<T>({
  required SearchProvider<T> searchProvider,
  int pageSize = PaginatedSearchController.defaultPageSize,
  Duration debounceDuration = PaginatedSearchController.defaultDebounceDuration,
  bool loadInitialPage = false,
}) {
  return NotifierProvider.autoDispose(
    () => PaginatedSearchController<T>(
      searchProvider: searchProvider,
      pageSize: pageSize,
      debounceDuration: debounceDuration,
      loadInitialPage: loadInitialPage,
    ),
  );
}
