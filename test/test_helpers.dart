import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pam_lab2/data/repositories/medical_repository.dart';

// Bundle de test care citește fișierul JSON real de pe disc
class FileAssetBundle extends CachingAssetBundle {
  final String? overrideContent;
  FileAssetBundle({this.overrideContent});

  @override
  Future<ByteData> load(String key) async {
    if (overrideContent != null) {
      return ByteData.sublistView(
        Uint8List.fromList(overrideContent!.codeUnits),
      );
    }
    final bytes = await File(key).readAsBytes();
    return ByteData.sublistView(bytes);
  }
}

MedicalRepository testRepository({String? content}) => MedicalRepository(
  bundle: FileAssetBundle(overrideContent: content),
  delay: Duration.zero,
);
