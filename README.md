Pagination made easy! This package depends on freezed and riverpod packages to make the workflow seamless.

## Features

<img src="https://user-images.githubusercontent.com/37986616/221440014-8e4d02cf-10ba-431b-b401-dcee81f45170.gif" height="600">

- Show loading items when fetching next batch
- Automatically load the next batch of items
- Customizable (error, load, show items)


## Getting started

This package depends on https://pub.dev/packages/riverpod and https://pub.dev/packages/freezed. Make sure you know how to use those packages.

## Usage

```dart

// this search contorller has 'int' items and 'dynamic' filter.
final paginatedSearchControllerProvider = StateNotifierProvider.autoDispose<
    BasePaginatedController<int, dynamic>, PaginatedState<int>>(
  (ref) => BasePaginatedController<int, dynamic>(
    searchProvider: (controller) async {
      // mock search delay
      await Future.delayed(const Duration(milliseconds: 400));
      return List.generate(12, (index) => index);
    },
    batchSize: 12,
  ),
);

class MyHomePage extends PaginatedSearchView<int, dynamic> {
  const MyHomePage({super.key, required super.paginatedController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends PaginatedSearchViewState<int, dynamic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              s8HeightBoxSliver,
              SliverAppBar(
                centerTitle: false,
                title: Text(
                  'Paginated Search',
                  style: context.textTheme.headline5.bold,
                ),
              ),
              const Text('Search through your data easily')
                  .withPadding(s16HorizontalPadding)
                  .asSliver,
              s32HeightBoxSliver,
              TextField(
                controller: ref
                    .read(paginatedSearchControllerProvider.notifier)
                    .searchController,
                onChanged: (value) =>
                    ref.read(paginatedSearchControllerProvider.notifier).search(),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: 'Search...',
                  filled: true,
                ),
              ).withPadding(s16HorizontalPadding).asSliver,
              s32HeightBoxSliver,
              PaginatedSliverListView(
                paginatedController: super.widget.paginatedController,
                itemBuilder: (item) => Card(
                  color: context.colorScheme.tertiaryContainer,
                  child: Text(
                    'Item $item',
                    style:
                        TextStyle(color: context.colorScheme.onTertiaryContainer),
                  ).withPadding(s16Padding),
                ).withPadding(s16HorizontalPadding),
                loadingBuilder: (_) => const CircularProgressIndicator.adaptive()
                    .alignCenter
                    .asSliver,
              ),
              s32HeightBoxSliver,
              PaginatedBottomWidget(
                paginatedController: super.widget.paginatedController,
                onGoingLoading: (context) =>
                    const CircularProgressIndicator.adaptive().alignCenter,
              ).asSliver,
            ],
          ),
        ).withHeaderOverlayGlow(context: context),
      ),
    );
  }
}
```

## Additional information

Please open issues in the github repo if something is not working as expected.
