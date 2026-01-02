import 'dart:typed_data';

sealed class CloakerState {
  const CloakerState();
}

class CloakerInitial extends CloakerState {
  const CloakerInitial();
}

class CloakerSuccess extends CloakerState {
  const CloakerSuccess({required this.message, required this.imageData});

  final Uint8List? imageData;
  final String message;

  CloakerSuccess copyWith({
    Uint8List? imageData,
    String? message,
  }) {
    return CloakerSuccess(
      message: message ?? this.message,
      imageData: imageData ?? this.imageData,
    );
  }
}

class CloakerFailure extends CloakerState {
  const CloakerFailure(this.message);

  final String message;
}
