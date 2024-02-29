## 2.1.0
* Removed the generic filter type F from paginated widgets

## 2.0.0
* BREAKING CHANGE: updated paginated controller and state to use a more clean architecture
* Added paginated helpers for constructing paginated controllers easily
* Added SearchProvider abstraction to make the paginated controller architecture cleaner

## 1.2.0
* Added sliver grid
* refactored some classes + code cleanup
* now we don't perform search if the previous filter equals the newly set filter

## 1.1.1
* changed the paginated controller requirement to be autoDispose again (You can keep the data with keepAlive)

## 1.1.0
* Now you can use normal state notifiers with the paginated search (previously had to use autoDispose state notifiers)
* Updated paginated controller to have more functionalities (init, refresh, ...)
* Fixed bugs with search timer
* Did some refactoring

## 1.0.4
* Added helper for getting the last item from the controller

## 1.0.3
* Made the items field in BasePaginatedController public to make it compatible with firebase cursors

## 1.0.2
* now require a filter to be passed in

## 1.0.1
* Updated generic types of the paginated search state

## 1.0.0
* Initial release for paginated search
