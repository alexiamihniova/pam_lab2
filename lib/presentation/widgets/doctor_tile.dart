import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../data/models/doctor.dart';
import 'app_avatar.dart';
import 'favorite_button.dart';

// Card pentru un doctor din lista "Nearby Doctor"
class DoctorTile extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const DoctorTile({
    super.key,
    required this.doctor,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Hero(
              tag: 'doctor-${doctor.id}',
              child: AppAvatar(url: doctor.avatarUrl, name: doctor.name),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    doctor.specialty,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          doctor.distance,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FavoriteButton(
              isFavorite: doctor.isFavorite,
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
      ),
    );
  }
}
