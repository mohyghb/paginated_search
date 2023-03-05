import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';

import 'paginated_state.dart';

typedef SearchProvider<T, F> = Future<List<T>> Function(
    BasePaginatedController<T, F> controller);

class BasePaginatedController<T, F> extends StateNotifier<PaginatedState<T>> {
  final List<T> items = [];
  final SearchProvider<T, F> searchProvider;
  final int batchSize;
  final TextEditingController searchController = TextEditingController();
  final Duration debounceDuration;
  // mutable variables
  F currentFilter;
  bool hasNoMoreItems = false;
  int page = 1;
  // to debounce multiple requests
  Timer? _timer;
  // helper getter for getting the last item if it exists
  // can be passed in the firebase queries for pagination
  T? get lastItemOrNull => items.isEmpty ? null : items.last;
  // helper getter
  String get query => searchController.text;


  BasePaginatedController({
    required this.searchProvider,
    required this.batchSize,
    required this.currentFilter,
    this.debounceDuration = const Duration(milliseconds: 500),
  }) : super(const PaginatedState.data([]));

  // used to fetch the first set of items
  // usually is called on the constructor when creating a provider
  void init() {
    if (items.isEmpty) {
      fetchNextBatch(addToPage: 0);
    }
  }

  // appends the data to the previous [_items]
  void updateItems(List<T> results) {
    hasNoMoreItems = results.length < batchSize;

    if (results.isEmpty) {
      state = PaginatedState.data(items);
    } else {
      state = PaginatedState.data(items..addAll(results));
    }
  }

  /// searches for the content inside the [searchController]
  /// resets all the other class variables such as [items], [hasNoMoreItems], and [page]
  void search({
    bool searchIfEmpty = false,
  }) async {
    if (query.isEmpty && !searchIfEmpty) {
      // if the search is empty, just show them the current items, no need to search
      state = PaginatedState.data(items);
      return;
    }

    state = const PaginatedState.loading();

    String savedQuery = query;
    // debounce search if this function is called within the given timeframe
    await Future.delayed(debounceDuration);

    if (savedQuery != query) {
      // there was another search issued, we will complete the other search and skip this one
      debugPrint('debounced search $savedQuery');
      return;
    }

    // resetting the variables for this new search
    items.clear();
    hasNoMoreItems = false;
    page = 1;

    _performSearch();
  }

  /// set the filter and do a [search]
  void setFilter(F filter, {bool performSearch = true}) {
    currentFilter = filter;
    if (performSearch) {
      // still perform a search when the query is empty
      search(searchIfEmpty: true);
    }
  }

  /// Fetch the next set of items from the same search
  /// [addToPage] is 0 when you call [init] since it shouldn't increase the page count
  /// you are querying the first page
  Future<void> fetchNextBatch({int addToPage = 1}) async {
    if (_timer?.isActive == true) {
      // already processing another request
      return;
    }

    _startTimer();

    if (hasNoMoreItems) {
      return;
    } else if (state == PaginatedState.onGoingLoading(items)) {
      return;
    }

    debugPrint('fetchNextBatch $query');
    // use the same query to fetch the next items in search
    // show ongoing loading
    state = PaginatedState.onGoingLoading(items);
    // increase the page number
    page += addToPage;

    _performSearch();
  }

  // starts the timer so that we don't perform multiple searches at once while
  // another search is in process (timer is active)
  void _startTimer() {
    _timer = Timer(const Duration(seconds: 1), () {});
  }

  /// calls the passed in [searchProvider] to retrieve items
  Future<void> _performSearch() async {
    List<T> results = await searchProvider(this);
    updateItems(results);
  }
}
