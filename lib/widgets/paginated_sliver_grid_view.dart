import 'package:flutter/material.dart';

import 'abstract_paginated_view.dart';

// Helper class for showing items of a paginated search in a Sliver Grid View
class PaginatedSliverGridView<T, F> extends AbstractPaginatedView<T,F> {

  final SliverGridDelegate gridDelegate;

  const PaginatedSliverGridView({
    super.key,
    required this.gridDelegate,
    required super.paginatedController,
    required super.itemBuilder,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
  });

  @override
  Widget whenData(BuildContext context, List<T> items) {
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
