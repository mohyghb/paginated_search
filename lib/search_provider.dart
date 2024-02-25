import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'paginated_state.dart';

// Searches items and provides them to PaginatedSearchController
abstract class SearchProvider<T> {
  /// perform a search, you can get the respective inputs of the search using [ref]
  /// e.g. filter, search text, etc... and customize the query based on the pagination [state]
  Future<List<T>> performSearch(Ref ref, PaginatedState<T> state);
}
