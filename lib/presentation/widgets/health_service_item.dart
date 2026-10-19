import 'package:flutter/material.dart';

import '../../data/models/home_data.dart';

// Culorile de fundal pentru fiecare serviciu
const Map<String, Color> _serviceColors = {
  'tooth': Color(0xFFFCE4EC),
  'eye': Color(0xFFE3F2FD),
  'lungs': Color(0xFFFFEBEE),
  'ear': Color(0xFFFFF3E0),
};

// Iconiță rotunjită pentru un serviciu medical
class HealthServiceItem extends StatelessWidget {
  final HealthService service;
  final VoidCallback? onTap;

  const HealthServiceItem({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _serviceColors[service.id] ?? const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(14),
            child: Image.asset(
              service.localIconPath,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.medical_services_outlined),
            ),
          ),
          const SizedBox(height: 6),
          Text(service.name, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
