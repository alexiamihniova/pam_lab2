import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

// Imagini locale folosite când nu există internet (din laboratorul anterior)
const Map<String, String> _localFallbacks = {
  'jonathan': 'assets/images/avatar_jonathan.jpg',
  'emmly': 'assets/images/doctor_emmly.jpg',
  'sonja': 'assets/images/doctor_sonja.jpg',
  'richar': 'assets/images/doctor_richar.png',
  'upul': 'assets/images/doctor_upul.jpg',
};

String? _fallbackFor(String name) {
  final lower = name.toLowerCase();
  for (final entry in _localFallbacks.entries) {
    if (lower.contains(entry.key)) return entry.value;
  }
  return null;
}

// Avatar reutilizabil: încarcă imaginea din rețea, cu fallback local
class AppAvatar extends StatelessWidget {
  final String url;
  final String name;
  final double size;
  final double? borderRadius; // null = cerc

  const AppAvatar({
    super.key,
    required this.url,
    required this.name,
    this.size = 52,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius ?? size / 2);
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: size,
        height: size,
        color: AppColors.placeholder,
        child: url.isEmpty
            ? _fallback()
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallback(),
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
              ),
      ),
    );
  }

  Widget _fallback() {
    final asset = _fallbackFor(name);
    if (asset != null) return Image.asset(asset, fit: BoxFit.cover);
    return Icon(Icons.person, size: size * 0.6, color: Colors.white);
  }
}
