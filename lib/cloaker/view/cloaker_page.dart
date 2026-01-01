import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stegano_app/cloaker/cubit/cloaker_cubit.dart';

class CloakerPage extends StatelessWidget {
  const CloakerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CloakerCubit(),
      child: const CloakerView(),
    );
  }
}

class CloakerView extends StatelessWidget {
  const CloakerView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
