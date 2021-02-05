


class DataState<T> {
  final bool isError;
  final bool isLoading;
  final bool isEmpty;
  final bool isLoaded;
  final T data;
  final Object errorObject;

  DataState({this.isError = false,
    this.isLoading = false,
    this.isEmpty = false,
    this.isLoaded = false,
    this.data,
    this.errorObject});

  factory DataState.loading({T data}) {
    return DataState(isLoading: true, data: data);
  }

  factory DataState.empty() {
    return DataState(isEmpty: true);
  }

  factory DataState.error({Object error}) {
    return DataState(isError: true, errorObject: error);
  }

  factory DataState.loaded(T data) {
    return DataState(data: data, isLoaded: true);
  }
}