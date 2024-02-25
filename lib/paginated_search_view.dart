import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'paginated_helpers.dart';
import 'paginated_state_type.dart';

typedef PaginationErrorBuilder = Widget Function(BuildContext context, Object? error);

// Automatically fetches the next batch using the paginatedController
abstract class PaginatedSearchView<T> extends ConsumerStatefulWidget {
  final PaginatedSearchControllerProvider<T> paginatedController;

  // whether to invalidate the [paginatedController] or not when this widget is disposed
  final bool invalidateOnDispose;

  const PaginatedSearchView({
    super.key,
    required this.paginatedController,
    this.invalidateOnDispose = true,
  });
}

abstract class PaginatedSearchViewState<P extends PaginatedSearchView> extends ConsumerState<P> {
  // Assign this controller to your scroll view. This allows for automatic fetching as user scrolls through the items
  final paginatedScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // show more items on page end
    paginatedScrollController.addListener(() => fetchNextBatchOnPageEnd(paginatedScrollController, context, ref));
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
      ref.read(widget.paginatedController.notifier).fetchNextPage();
    }
  }
}

// This widget should be placed at the bottom of your view so that when a user
// reaches the end of a list, we show them a progress indicator indicating that we
// are loading the next batch of items
class PaginatedBottomWidget<T> extends ConsumerWidget {
  final PaginatedSearchControllerProvider<T> paginatedController;

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
    final state = ref.watch(paginatedController);
    switch(state.type) {
      case PaginatedStateType.data:
      case PaginatedStateType.loading:
      case PaginatedStateType.error:
        return const SizedBox.shrink();
      case PaginatedStateType.onGoingLoading:
        return onGoingLoading(context);
      case PaginatedStateType.onGoingError:
        return onGoingErrorBuilder?.call(context, state.error) ?? const SizedBox.shrink();
    }
  }
}
