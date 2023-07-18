import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../paginated_search.dart';
import 'abstract_paginated_view.dart';

// Helper class for showing items of a paginated search in a sliver list view
class PaginatedSliverListView<T, F> extends AbstractPaginatedView<T,F> {

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