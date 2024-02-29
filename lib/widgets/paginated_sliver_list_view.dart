import 'package:flutter/material.dart';

import 'abstract_paginated_view.dart';

// Helper class for showing items of a paginated search in a sliver list view
class PaginatedSliverListView<T> extends AbstractPaginatedView<T> {
  const PaginatedSliverListView({
    super.key,
    required super.paginatedController,
    required super.itemBuilder,
    super.loadingBuilder,
    super.errorBuilder,
    super.emptyBuilder,
  });

  @override
  Widget whenData(BuildContext context, List<T> items) {
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
