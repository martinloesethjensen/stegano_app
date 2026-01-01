import 'package:bloc/bloc.dart';
import 'package:stegano_app/src/rust/api/simple.dart' as lib;

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void answerToEverything() {
    final answer = lib.answerToEverything();
    emit(answer);
  }
}
