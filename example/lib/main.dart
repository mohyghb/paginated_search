import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moye/moye.dart';
import 'package:paginate/paginate.dart';

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

final paginatedSearchControllerProvider = StateNotifierProvider.autoDispose<
    BasePaginatedController<int, int>, PaginatedState<int>>(
  (ref) {
    return BasePaginatedController<int, int>(
        searchProvider: (controller) async {
          // mock search delay
          controller.currentFilter;
          await Future.delayed(const Duration(milliseconds: 400));
          return List.generate(12, (index) => index);
        },
        batchSize: 12,
        currentFilter: 2);
  },
);

class MyHomePage extends PaginatedSearchView<int, int> {
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
        bottom: false,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            s8HeightBoxSliver,
            SliverAppBar(
              centerTitle: false,
              title: Text(
                'Paginated Search',
                style: context.textTheme.headlineSmall.bold,
              ),
            ),
            const Text('Search through your data easily')
                .withPadding(s16HorizontalPadding)
                .asSliver,
            s32HeightBoxSliver,
            TextField(
              controller: ref
                  .watch(paginatedSearchControllerProvider.notifier)
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
              paginatedController: paginatedSearchControllerProvider,
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
              paginatedController: paginatedSearchControllerProvider,
              onGoingLoading: (context) =>
                  const CircularProgressIndicator.adaptive().alignCenter,
            ).asSliver,
          ],
        ),
      ).withHeaderOverlayGlow(context: context),
    ));
  }
}
