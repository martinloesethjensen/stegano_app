import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:stegano_app/cloaker/cubit/cloaker_state.dart';
import 'package:stegano_app/src/rust/api/cloaker.dart' as cloaker;

class CloakerCubit extends Cubit<CloakerState> {
  CloakerCubit() : super(const CloakerInitial());

  void cloak(Uint8List bytes, String message) {
    cloaker.cloak(imageBytes: bytes, message: message);
    emit(const CloakerSuccess(message: '******'));
  }

  void uncloak(Uint8List bytes) {
    final result = cloaker.uncloak(imageBytes: bytes.toList());
    emit(CloakerSuccess(message: result));
  }
}
