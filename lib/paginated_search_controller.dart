import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';

import 'paginated_state.dart';
import 'paginated_state_type.dart';
import 'search_provider.dart';

class PaginatedSearchController<T>
    extends AutoDisposeNotifier<PaginatedState<T>> {
  static const initialPage = 0;
  static const defaultPageSize = 20;
  static const defaultDebounceDuration = Duration(milliseconds: 500);

  // The function that is called to generate a search
  final SearchProvider<T> searchProvider;

  // The amount of time between debouncing a search. Useful for when having a search as you type feature
  // so that you don't send multiple queries to your backend for each individual keystrokes
  final Duration debounceDuration;

  // True if the initial batch should be loaded when the view is opened
  // False if no search items should be available on initial load
  final bool loadInitialPage;

  // The number of items to retrieve for a page
  final int pageSize;

  // Counter used for debouncing
  int _debounceCounter = 0;

  Timer? _timer;

  PaginatedSearchController({
    required this.searchProvider,
    this.pageSize = defaultPageSize,
    this.debounceDuration = defaultDebounceDuration,
    this.loadInitialPage = false,
  });

  @override
  PaginatedState<T> build() {
    if (loadInitialPage) {
      _loadInitialPage();
    }
    return PaginatedState(
      page: initialPage,
      pageSize: this.pageSize,
      type: PaginatedStateType.data,
      hasNoMoreItems: false,
      items: [],
    );
  }

  // The function to be called for the initial search, whether it automatically gets called as user types
  // or when they hit the search button
  void search() async {
    state = state.copyWith(type: PaginatedStateType.loading);
    _debounceCounter++;
    int tempDebounceCounter = _debounceCounter;

    // debounce search if this function is called within the given timeframe
    await Future.delayed(debounceDuration);

    if (_debounceCounter != tempDebounceCounter) {
      // there was another search requested, we will complete the other search and skip this one
      debugPrint('debounced search $tempDebounceCounter');
      return;
    }

    // resetting the variables for this new search
    state = state.getInitialSearchState();
    _performSearch();
  }

  // Resets the state of the pagination search and searches the initial page again
  void refresh() {
    clear();
    _loadInitialPage();
  }

  // Resets the state of the pagination search without searching the initial page again
  void clear() {
    state = build();
  }

  /// Fetch the next set of items from the same search
  Future<void> fetchNextPage() async {
    if (_timer?.isActive == true) {
      // already processing another request
      return;
    }

    _startTimer();

    if (state.hasNoMoreItems) {
      return;
    } else if (state.type == PaginatedStateType.onGoingLoading) {
      return;
    }

    debugPrint('PaginatedSearchController.fetchNextBatch');

    // use the same query to fetch the next items in search
    // show ongoing loading
    state = state.copyWith(type: PaginatedStateType.onGoingLoading);

    _performSearch();
  }

  // Loads the initial page
  void _loadInitialPage() {
    search();
  }

  void _updateItems(List<T> results) {
    // if the results returned is less than the [state.pageSize], then we assume that search provider doesn't have any
    // more items to provide
    bool hasNoMoreItems = results.length < state.pageSize;
    final updatedItems = [...state.items, ...results];

    state = state.copyWith(
      type: PaginatedStateType.data,
      hasNoMoreItems: hasNoMoreItems,
      items: updatedItems,
      page: state.page + 1,
    );
  }

  /// calls the passed in [searchProvider] to retrieve items
  Future<void> _performSearch() async {
    try {
      final items = await searchProvider.performSearch(ref, state);
      _updateItems(items);
    } catch (e) {
      state = state.copyWith(
        type: state.type == PaginatedStateType.loading
            ? PaginatedStateType.error
            : PaginatedStateType.onGoingError,
        error: e,
      );
    }
  }

  // starts the timer so that we don't perform multiple searches at once while
  // another search is in process (timer is active)
  // Used for [fetchNextBatch]
  void _startTimer() {
    _timer = Timer(const Duration(seconds: 1), () {});
  }
}
