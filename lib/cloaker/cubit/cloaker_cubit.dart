import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:stegano_app/cloaker/cubit/cloaker_state.dart';
import 'package:stegano_app/src/rust/api/cloaker.dart' as cloaker;

class CloakerCubit extends Cubit<CloakerState> {
  CloakerCubit() : super(const CloakerInitial());

  void cloak(Uint8List bytes, String message) {
    final messageAsBytes = utf8.encode(message);
    final cloakedMessage = cloaker.cloak(bytes: bytes, message: messageAsBytes);

    if (cloakedMessage == null) {
      emit(const CloakerFailure('Failed to cloak message'));
    }

    emit(const CloakerSuccess());
  }

  void uncloak(Uint8List bytes) {
    final result = cloaker.uncloak(bytes: bytes.toList());
    print(utf8.decode(result));

    emit(const CloakerSuccess());
  }
}
