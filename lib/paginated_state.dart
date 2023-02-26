import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_state.freezed.dart';

typedef WidgetFromItemBuilder<T> = Widget Function(T item);

@freezed
abstract class PaginatedState<T> with _$PaginatedState<T> {
  const factory PaginatedState.data(List<T> items) = _Data;
  const factory PaginatedState.loading() = _Loading;
  const factory PaginatedState.error(Object? e, [StackTrace? stk]) = _Error;
  const factory PaginatedState.onGoingLoading(List<T> items) = _OnGoingLoading;
  const factory PaginatedState.onGoingError(List<T> items, Object? e,
      [StackTrace? stk]) = _OnGoingError;
}
