// Helpers to efficiently add pagination to your app

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paginated_search/paginated_search.dart';

typedef PaginatedSearchControllerProvider<T, Q> = AutoDisposeNotifierProvider<
    PaginatedSearchController<T, Q>, PaginatedState<T, Q>>;
typedef PaginationErrorBuilder = Widget Function(
    BuildContext context, Object? error, StackTrace? stackTrace);

/// Create a paginated controller provider easily. For example
/// ```
/// final recipesPaginatedControllerProvider = createPaginatedController(searchProvider: RecipesSearchProvider());
/// ```
/// This would simplify your controller creation and make your code easier to read.
AutoDisposeNotifierProvider<PaginatedSearchController<T, Q>,
    PaginatedState<T, Q>> createPaginatedController<T, Q>({
  required SearchProvider<T, Q> searchProvider,
  int pageSize = PaginatedSearchController.defaultPageSize,
  Duration debounceDuration = PaginatedSearchController.defaultDebounceDuration,
  Q? initialQuery,
  bool debugLoggingEnabled = true,
}) {
  return NotifierProvider.autoDispose(
    () => PaginatedSearchController<T, Q>(
      searchProvider: searchProvider,
      pageSize: pageSize,
      debounceDuration: debounceDuration,
      initialPageQuery: initialQuery,
      debugLoggingEnabled: debugLoggingEnabled,
    ),
  );
}
