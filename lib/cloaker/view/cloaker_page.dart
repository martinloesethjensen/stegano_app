import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:stegano_app/cloaker/cubit/cloaker_cubit.dart';
import 'package:stegano_app/cloaker/cubit/cloaker_state.dart';

// TODO(mlj): remove mock method
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
        spacing: 8,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<CloakerCubit>().cloak(
                generateMockImage(200, 200),
                'Some message to hide',
              );
            },
            child: const Icon(Icons.hide_image),
          ),
          BlocBuilder<CloakerCubit, CloakerState>(
            builder: (context, state) {
              return FloatingActionButton(
                onPressed: () {
                  if (state is CloakerSuccess && state.imageData != null) {
                    context.read<CloakerCubit>().uncloak(
                      state.imageData!,
                    );
                  }
                },
                child: const Icon(Icons.visibility),
              );
            },
          ),
        ],
      ),
    );
  }
}
