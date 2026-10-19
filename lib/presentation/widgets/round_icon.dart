import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

// Iconiță rotundă mică (chat/call/video) de lângă numele doctorului
class RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const RoundIcon({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: AppColors.primary),
      ),
    );
  }
}
