import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../paginated_search.dart';

class PaginatedSliverListView<T, F> extends ConsumerWidget {
  final AutoDisposeStateNotifierProvider<BasePaginatedController<T, F>,
      PaginatedState<T>> paginatedController;
  final WidgetFromItemBuilder<T> itemBuilder;
  final PaginationErrorBuilder? errorBuilder;
  final WidgetBuilder? loadingBuilder;

  // used when the items loaded is empty
  final WidgetBuilder? emptyBuilder;

  final SliverGridDelegate gridDelegate;

  const PaginatedSliverListView({
    super.key,
    required this.gridDelegate,
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
      data: (items) => _buildGrid(context, items),
      loading: () =>
          loadingBuilder?.call(context) ?? const SliverToBoxAdapter(),
      error: (e, stk) =>
          errorBuilder?.call(context, e) ?? const SliverToBoxAdapter(),
      onGoingLoading: (items) => _buildGrid(context, items),
      onGoingError: (items, e, stk) => _buildGrid(context, items),
    );
  }

  Widget _buildGrid(BuildContext context, List<T> items) {
    if (items.isEmpty && emptyBuilder != null) {
      return emptyBuilder?.call(context) ?? const SliverToBoxAdapter();
    }
    return SliverGrid(
      gridDelegate: gridDelegate,
      delegate: SliverChildBuilderDelegate(
        (context, index) => itemBuilder(items[index]),
        childCount: items.length,
      ),
    );
  }
}
