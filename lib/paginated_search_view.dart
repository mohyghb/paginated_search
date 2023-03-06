import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'base_paginated_controller.dart';
import 'paginated_state.dart';

typedef PaginationErrorBuilder = Widget Function(
    BuildContext context, Object? error);

// Automatically fetches the next batch using the paginatedController
abstract class PaginatedSearchView<T, F> extends ConsumerStatefulWidget {
  final StateNotifierProvider<BasePaginatedController<T, F>, PaginatedState<T>>
      paginatedController;

  // whether to invalidate the [paginatedController] or not when this widget is disposed
  final bool invalidateOnDispose;

  const PaginatedSearchView({
    super.key,
    required this.paginatedController,
    this.invalidateOnDispose = true,
  });
}

abstract class PaginatedSearchViewState<P extends PaginatedSearchView>
    extends ConsumerState<P> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // show more items on page end
    scrollController.addListener(
        () => fetchNextBatchOnPageEnd(scrollController, context, ref));
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.invalidateOnDispose) {
      ref.invalidate(widget.paginatedController);
    }
  }

  // helper method to fetch next batch of search items when user reaches near the end
  // of the max scrolling position
  void fetchNextBatchOnPageEnd(
    ScrollController scrollController,
    BuildContext context,
    WidgetRef ref,
  ) {
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;
    double delta = MediaQuery.of(context).size.width * 0.20;
    if (maxScroll - currentScroll <= delta) {
      ref.read(widget.paginatedController.notifier).fetchNextBatch();
    }
  }
}

// Helper class for showing items of a paginated search in a sliver list view
class PaginatedSliverListView<T, F> extends ConsumerWidget {
  final StateNotifierProvider<BasePaginatedController<T, F>, PaginatedState<T>>
      paginatedController;
  final WidgetFromItemBuilder<T> itemBuilder;
  final PaginationErrorBuilder? errorBuilder;
  final WidgetBuilder? loadingBuilder;

  // used when the items loaded is empty
  final WidgetBuilder? emptyBuilder;

  const PaginatedSliverListView({
    super.key,
    required this.paginatedController,
    required this.itemBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paginatedController);

    return state.when(
      data: (items) => _buildSliverList(context, items),
      loading: () =>
          loadingBuilder?.call(context) ?? const SliverToBoxAdapter(),
      error: (e, stk) =>
          errorBuilder?.call(context, e) ?? const SliverToBoxAdapter(),
      onGoingLoading: (items) => _buildSliverList(context, items),
      onGoingError: (items, e, stk) => _buildSliverList(context, items),
    );
  }

  Widget _buildSliverList(BuildContext context, List<T> items) {
    if (items.isEmpty && emptyBuilder != null) {
      return emptyBuilder?.call(context) ?? const SliverToBoxAdapter();
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => itemBuilder(items[index]),
        childCount: items.length,
      ),
    );
  }
}

// This widget should be placed at the bottom of your view so that when a user
// reaches the end of a list, we show them a progress indicator indicating that we
// are loading the next batch of items
class PaginatedBottomWidget extends ConsumerWidget {
  final StateNotifierProvider<BasePaginatedController, PaginatedState>
      paginatedController;

  final PaginationErrorBuilder? onGoingErrorBuilder;
  final WidgetBuilder onGoingLoading;

  const PaginatedBottomWidget({
    super.key,
    required this.paginatedController,
    required this.onGoingLoading,
    this.onGoingErrorBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(paginatedController).maybeWhen(
          onGoingError: (items, e, stk) =>
              onGoingErrorBuilder?.call(context, e) ?? const SizedBox.shrink(),
          onGoingLoading: (items) => onGoingLoading(context),
          orElse: () => const SizedBox.shrink(),
        );
  }
}
