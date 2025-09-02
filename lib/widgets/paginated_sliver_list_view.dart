import 'package:flutter/material.dart';

import 'abstract_paginated_view.dart';

// Helper class for showing items of a paginated search in a sliver list view
class PaginatedSliverListView<T, Q> extends AbstractPaginatedView<T, Q> {
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final int? Function(Key)? findChildIndexCallback;

  const PaginatedSliverListView({
    super.key,
    required super.paginatedController,
    required super.itemBuilder,
    super.loadingBuilder,
    super.errorBuilder,
    super.emptyBuilder,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.findChildIndexCallback,
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
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        findChildIndexCallback: findChildIndexCallback,
      ),
    );
  }
}
