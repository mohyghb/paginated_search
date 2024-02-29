// Helpers to efficiently add pagination to your app

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paginated_search/paginated_search.dart';

typedef PaginatedSearchControllerProvider<T> = AutoDisposeNotifierProvider<
    PaginatedSearchController<T>, PaginatedState<T>>;
typedef PaginationErrorBuilder = Widget Function(
    BuildContext context, Object? error, StackTrace? stackTrace);

/// Create a paginated controller provider easily. For example
/// ```
/// final recipesPaginatedControllerProvider = createPaginatedController(searchProvider: RecipesSearchProvider());
/// ```
/// This would simplify your controller creation and make your code easier to read.
AutoDisposeNotifierProvider<PaginatedSearchController<T>, PaginatedState<T>>
    createPaginatedController<T>({
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
