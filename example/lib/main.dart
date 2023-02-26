import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moye/moye.dart';
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
      home: MyHomePage(
        paginatedController: paginatedSearchControllerProvider,
      ),
    );
  }
}

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
