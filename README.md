Pagination made easy with Riverpod!

## Features

<img src="https://github.com/mohyghb/paginated_search/assets/37986616/15bce472-49fe-4411-893a-a28bff79cdb6" height="600">

- Show loading items when fetching next page
- Automatically load the next page of items as user scrolls towards the bottom of the list (infinite-scroll-view)
- Customizable: customize error, loader, and other views
- Set a initial query for the paginated search controller to load in when view is initialized


## Getting started

This package depends on https://pub.dev/packages/riverpod. Make sure you know how to use those packages.

## Usage

Create a SearchProvider first. SearchProviders provide the search data to the pagination controller. You can use the paginated state to know more about the current query, which page you are on, how many items to get for each page, etc...

```dart
// <MyItem, MyQuery> Specifies the type of the item and the type of the query to be used inside this search provider
// <String, String> Means the type of the query and the type of the item is both String

class MockSearchProvider extends SearchProvider<String, String> {
  @override
  Future<List<String>> performSearch(Ref ref, PaginatedState<String, String> state) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.generate(
        state.pageSize, (index) => '${state.query ?? "No Query"} - ${state.page * state.pageSize + index}');
  }
}
```

Create a paginated controller provider to allow pagination view handle different flows.

```dart
final paginatedSearchControllerProvider = createPaginatedController(
    searchProvider: MockSearchProvider(),
    // Specify an initial query so that the controller can load the initial page with this query
    initialQuery: "Initial Query"
);
```

Now you can create your paginated search view:

```dart
class MyHomePage extends PaginatedSearchView<String, String> {
  const MyHomePage({
    super.key,
    required super.paginatedController,
    super.invalidateOnDispose = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends PaginatedSearchViewState<MyHomePage>
    with TickerProviderStateMixin {
  late final tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: SafeArea(
            child: CustomScrollView(
              controller: paginatedScrollController,
              slivers: [
                s16HeightBoxSliver,
                Text(
                  'Paginated Search',
                  style: context.textTheme.headlineMedium.bold,
                ).withPadding(s16HorizontalPadding).asSliver,
                const Text('Search through your data easily')
                    .withPadding(s16HorizontalPadding)
                    .asSliver,
                s32HeightBoxSliver,
                TextField(
                  onChanged: (value) =>
                      ref.read(paginatedSearchControllerProvider.notifier).search(query: value),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded),
                    hintText: 'Search...',
                    filled: true,
                  ),
                ).withPadding(s16HorizontalPadding).asSliver,
                s32HeightBoxSliver,
                PaginatedSliverListView(
                  paginatedController: paginatedSearchControllerProvider,
                  itemBuilder: (item) => Card(
                    elevation: 8,
                    child: Text(
                      '$item',
                      style: TextStyle(
                          color: context.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold),
                    ).withPadding(s24Padding),
                  ).withPadding(s4Vertical8Horizontal),
                  loadingBuilder: (_) => const CircularProgressIndicator.adaptive()
                      .alignCenter
                      .asSliver,
                  errorBuilder: (context, error, st) =>
                  const Text("Error happened").asSliver,
                ),
                s32HeightBoxSliver,
                PaginatedBottomWidget(
                  paginatedController: paginatedSearchControllerProvider,
                  onGoingLoading: (context) =>
                  const CircularProgressIndicator.adaptive().alignCenter,
                  onGoingErrorBuilder: (context, error, st) =>
                  const Text("Something went wrong").alignCenter,
                ).asSliver,
              ],
            ),
          ).withHeaderOverlayGlow(context: context),
        ));
  }
}
```

## Additional information

Please open issues in the github repo if something is not working as expected.
