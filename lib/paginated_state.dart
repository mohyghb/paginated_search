import 'package:flutter/material.dart';
import 'package:paginated_search/paginated_search_controller.dart';

import 'paginated_state_type.dart';

typedef WidgetFromItemBuilder<T> = Widget Function(T item);

/// An state of paginated search. Contains information regarding which [page] we are on, what the [pageSize] of each page
/// is, what the current [type] of this state is, its loaded [items] and more.
class PaginatedState<T, Q> {
  // which page of search we are on, the first page is denoted as 0
  final int page;
  // The number of items to retrieve for a page
  final int pageSize;
  // which type of state are we on: data, loading, error, onGoingLoading, onGoingError
  final PaginatedStateType type;
  // When the search provider doesn't have anymore items to provide based on the query
  final bool hasNoMoreItems;
  // Search items
  final List<T> items;
  // only applicable if the type is [error] or [onGoingError]
  final Object? error;
  final StackTrace? stackTrace;
  final Q? query;

  // Helper fields
  // Useful to use when your search provider needs the latest returned item in order to determine the
  // next page to be sent
  T? get lastItemOrNull => items.isEmpty ? null : items.last;

  const PaginatedState({
    required this.page,
    required this.pageSize,
    required this.type,
    required this.hasNoMoreItems,
    required this.items,
    this.query,
    this.error,
    this.stackTrace,
  });

  PaginatedState<T, Q> getInitialSearchState({required Q? query}) {
    return PaginatedState<T, Q>(
      page: PaginatedSearchController.initialPage,
      pageSize: pageSize,
      type: PaginatedStateType.loading,
      hasNoMoreItems: false,
      items: [],
      query: query,
    );
  }

  PaginatedState<T, Q> copyWith({
    int? page,
    int? pageSize,
    PaginatedStateType? type,
    bool? hasNoMoreItems,
    List<T>? items,
    Object? error,
    StackTrace? stackTrace,
    Q? query,
  }) {
    return PaginatedState<T, Q>(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      type: type ?? this.type,
      hasNoMoreItems: hasNoMoreItems ?? this.hasNoMoreItems,
      items: items ?? this.items,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      query: query ?? this.query,
    );
  }
}
