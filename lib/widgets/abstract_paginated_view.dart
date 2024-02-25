import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paginated_search/paginated_helpers.dart';
import 'package:paginated_search/paginated_search_controller.dart';
import 'package:paginated_search/paginated_search_view.dart';
import 'package:paginated_search/paginated_state.dart';
import 'package:paginated_search/paginated_state_type.dart';

abstract class AbstractPaginatedView<T, F> extends ConsumerWidget {
  final PaginatedSearchControllerProvider<T> paginatedController;
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
    final items = state.items;

    return switch (state.type) {
      PaginatedStateType.data => whenData(context, items),
      PaginatedStateType.loading => loadingBuilder?.call(context) ?? const SliverToBoxAdapter(),
      PaginatedStateType.error => errorBuilder?.call(context, state.error) ?? const SliverToBoxAdapter(),
      PaginatedStateType.onGoingLoading => whenData(context, items),
      PaginatedStateType.onGoingError => whenData(context, items),
    };
  }

  /// This is the callback used to build the list/grid when data is available
  Widget whenData(BuildContext context, List<T> items);
}
