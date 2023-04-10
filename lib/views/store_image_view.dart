import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StoreimageView extends StatelessWidget {
  final Reference image;
  const StoreimageView({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
        future: image.getData(),
        builder: (context, snapshoot) {
          switch (snapshoot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:

            case ConnectionState.active:
              return const Center(
                child: Center(child: CircularProgressIndicator()),
              );
            case ConnectionState.done:
              if (snapshoot.hasData) {
                final data = snapshoot.data;
                return Image.memory(
                  data!,
                  fit: BoxFit.cover,
                );
              } else {
                return const Center(
                  child: Text("No image"),
                );
              }

            default:
              return const Center(
                child: Text("No image"),
              );
          }
        });
  }
}
