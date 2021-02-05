import 'package:flutter/material.dart';
import 'package:naext/blocs/bloc_base.dart';


class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }): super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context){
    BlocProvider<T> provider = context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>>{
  @override
  void dispose(){
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return widget.child;
  }
}



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

  @override
  String toString() {
    return 'DataState{isError: $isError, isLoading: $isLoading, isEmpty: $isEmpty, isLoaded: $isLoaded, data: $data}';
  }
}