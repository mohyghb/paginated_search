import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../paginated_search.dart';
import 'abstract_paginated_view.dart';

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
