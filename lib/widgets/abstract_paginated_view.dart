import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paginated_search/base_paginated_controller.dart';
import 'package:paginated_search/paginated_search_view.dart';
import 'package:paginated_search/paginated_state.dart';

abstract class AbstractPaginatedView<T, F> extends ConsumerWidget {
  final AutoDisposeStateNotifierProvider<BasePaginatedController<T, F>,
      PaginatedState<T>> paginatedController;
  final WidgetFromItemBuilder<T> itemBuilder;
  final PaginationErrorBuilder? errorBuilder;
  final WidgetBuilder? loadingBuilder;
  // used when the items loaded is empty
  final WidgetBuilder? emptyBuilder;

  const AbstractPaginatedView({
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
      data: (items) => whenData(context, items),
      loading: () =>
      loadingBuilder?.call(context) ?? const SliverToBoxAdapter(),
      error: (e, stk) =>
      errorBuilder?.call(context, e) ?? const SliverToBoxAdapter(),
      onGoingLoading: (items) => whenData(context, items),
      onGoingError: (items, e, stk) => whenData(context, items),
    );
  }

  /// This is the callback used to build the list/grid when data is available
  Widget whenData(BuildContext context, List<T> items);

}