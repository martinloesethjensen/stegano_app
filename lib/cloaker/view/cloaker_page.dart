import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:stegano_app/cloaker/cubit/cloaker_cubit.dart';
import 'package:stegano_app/cloaker/cubit/cloaker_state.dart';

Uint8List generateMockImage(int width, int height) {
  // Create a blank image
  final image = img.Image(width: width, height: height);

  // Fill it with a color (optional)
  img.fill(image, color: img.ColorRgb8(255, 0, 0));

  // Encode it as PNG bytes
  return Uint8List.fromList(img.encodePng(image));
}

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
    return Scaffold(
      body: BlocBuilder<CloakerCubit, CloakerState>(
        builder: (context, state) {
          return switch (state) {
            CloakerSuccess() => Center(
              child: Text('Success: ${state.message}'),
            ),
            _ => const Placeholder(),
          };
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<CloakerCubit>().cloak(
                generateMockImage(200, 200),
                'Martin is awesome',
              );
            },
            child: const Icon(Icons.hide_image),
          ),
          FloatingActionButton(
            onPressed: () {
              context.read<CloakerCubit>().uncloak(
                generateMockImage(200, 200),
              );
            },
            child: const Icon(Icons.visibility),
          ),
        ],
      ),
    );
  }
}
