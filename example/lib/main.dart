import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moye/moye.dart';
import 'package:paginated_search/paginated_helpers.dart';
import 'package:paginated_search/paginated_search.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: Colors.blue.shade900,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(paginatedController: paginatedSearchControllerProvider),
    );
  }
}

final paginatedSearchControllerProvider =
    createPaginatedController(searchProvider: MockSearchProvider(), loadInitialPage: true);

class MockSearchProvider extends SearchProvider<int> {
  @override
  Future<List<int>> performSearch(Ref ref, PaginatedState<int> state) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.generate(
        state.pageSize, (index) => state.page * state.pageSize + index);
  }
}

class MyHomePage extends PaginatedSearchView<int> {
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
                  ref.read(paginatedSearchControllerProvider.notifier).search(),
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
                  'Item $item',
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
