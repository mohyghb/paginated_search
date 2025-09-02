import 'package:flutter/material.dart';

import 'abstract_paginated_view.dart';

// Helper class for showing items of a paginated search in a Sliver Grid View
class PaginatedSliverGridView<T, Q> extends AbstractPaginatedView<T, Q> {
  final SliverGridDelegate gridDelegate;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final int? Function(Key)? findChildIndexCallback;

  const PaginatedSliverGridView({
    super.key,
    required this.gridDelegate,
    required super.paginatedController,
    required super.itemBuilder,
    super.emptyBuilder,
    super.errorBuilder,
    super.loadingBuilder,
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
    return SliverGrid(
      gridDelegate: gridDelegate,
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
