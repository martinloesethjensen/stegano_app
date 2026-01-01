sealed class CloakerState {
  const CloakerState();
}

class CloakerInitial extends CloakerState {
  const CloakerInitial();
}

class CloakerSuccess extends CloakerState {
  const CloakerSuccess();
}

class CloakerFailure extends CloakerState {
  const CloakerFailure(this.message);

  final String message;
}
