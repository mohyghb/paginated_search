enum PaginatedStateType {
  // Search has been successful and data is available
  data,
  // Initial search loading
  loading,
  // Initial search error
  error,
  // When we are loading the next batch of items (not the initial batch)
  onGoingLoading,
  // When we get an error while getting the next batch of items (not the initial batch)
  onGoingError,
}
