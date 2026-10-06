// Importăm pachetul Material Design al Flutter
import 'package:flutter/material.dart';

// Punctul de intrare al aplicației
void main() {
  runApp(const MedicalApp());
}

// Culoarea principală a designului, culoarea ta exactă
const Color kPrimaryTeal = Color(0xFF2BACBE);
// Culoarea de fundal, gri foarte deschis
const Color kBackground = Color(0xFFF4F5F7);

class MedicalApp extends StatelessWidget {
  const MedicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical App UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryTeal,
        scaffoldBackgroundColor: kBackground,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// =========================================================================
// ECRAN 1: HOMESCREEN
// =========================================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Rândul de sus: avatar + salut + notificare ----
              Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Color(0xFFE0E0E0),
                    backgroundImage: AssetImage(
                      'assets/images/avatar_jonathan.jpg',
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, Jonathan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'May you always be healthy',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: Colors.black87,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ---- Bara de căutare ----
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search something',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    Icon(Icons.tune, color: Colors.grey),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---- Cardul "Appointment" (teal) ----
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppointmentDetailsScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: kPrimaryTeal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Appointment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              color: Colors.white, size: 16),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: const [
                          Icon(Icons.calendar_today,
                              color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text(
                            '22 October, 2023',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Icon(Icons.access_time,
                              color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text(
                            '08:00 AM - 10.30 AM',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // ---- Card interior alb cu doctorul ----
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundColor: Color(0xFFE0E0E0),
                              backgroundImage: AssetImage(
                                'assets/images/doctor_richar.png',
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dr. Richar Kandowen',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Child Specialist',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: kBackground,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline,
                                size: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // ---- Secțiunea "Health Services" ----
              _SectionHeader(title: 'Health Services', onSeeAll: () {}),
              const SizedBox(height: 12),
              // Iconițele sunt încărcate din assets/images
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _HealthServiceItem(
                    iconPath: 'assets/images/icon_tooth.png',
                    label: 'Tooth',
                    bgColor: Color(0xFFFCE4EC),
                  ),
                  _HealthServiceItem(
                    iconPath: 'assets/images/icon_eye.png',
                    label: 'Eye',
                    bgColor: Color(0xFFE3F2FD),
                  ),
                  _HealthServiceItem(
                    iconPath: 'assets/images/icon_lungs.png',
                    label: 'Lungs',
                    bgColor: Color(0xFFFFEBEE),
                  ),
                  _HealthServiceItem(
                    iconPath: 'assets/images/icon_ear.png',
                    label: 'Ear',
                    bgColor: Color(0xFFFFF3E0),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ---- Secțiunea "Nearby Doctor" ----
              _SectionHeader(title: 'Nearby Doctor', onSeeAll: () {}),
              const SizedBox(height: 12),
              const _DoctorTile(
                name: 'Dr. Emmly Lestiryno',
                specialty: 'General Practitioner',
                location: '3167 Durgan Shores - 500M from you',
                imagePath: 'assets/images/doctor_emmly.jpg',
              ),
              const SizedBox(height: 14),
              const _DoctorTile(
                name: 'Dr. Sonja Littel',
                specialty: 'Dental Specialist',
                location: '950 Sigrid Port - 753M from you',
                imagePath: 'assets/images/doctor_sonja.jpg',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget reutilizabil pentru titlul de secțiune + "See All"
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            'See All',
            style: TextStyle(color: kPrimaryTeal, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

// Iconiță rotunjită pentru fiecare serviciu medical, cu imagine din assets
class _HealthServiceItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final Color bgColor;

  const _HealthServiceItem({
    required this.iconPath,
    required this.label,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(14),
          child: Image.asset(iconPath, fit: BoxFit.contain),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

// Card pentru fiecare doctor din lista "Nearby Doctor"
class _DoctorTile extends StatelessWidget {
  final String name;
  final String specialty;
  final String location;
  final String imagePath;

  const _DoctorTile({
    required this.name,
    required this.specialty,
    required this.location,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: const Color(0xFFE0E0E0),
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              Text(specialty,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: kPrimaryTeal),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Icon(Icons.favorite_border, color: Colors.grey),
      ],
    );
  }
}

// =========================================================================
// ECRAN 2: APPOINTMENT DETAILS
// =========================================================================
class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({super.key});

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  String _selectedHour = '11.00 AM';
  String _selectedDay = 'Sun 4';

  final List<String> _hours = ['10.00 AM', '11.00 AM', '12.00 PM'];
  final List<String> _days = ['Sun 4', 'Mon 5', 'Tue 6'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Bara de sus: back + titlu ----
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, size: 18),
                  ),
                  const Text(
                    'Appointment',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryTeal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ---- Info doctor ----
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/doctor_upul.jpg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Dr. Upul',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            _RoundIcon(icon: Icons.chat_bubble_outline),
                            SizedBox(width: 6),
                            _RoundIcon(icon: Icons.call_outlined),
                            SizedBox(width: 6),
                            _RoundIcon(icon: Icons.videocam_outlined),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Denteeth',
                          style: TextStyle(color: kPrimaryTeal, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Text(
                              'Payment',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 30),
                            Text(
                              '\$120.00',
                              style: TextStyle(
                                color: kPrimaryTeal,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ---- Detalii ----
              const Text(
                'Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Worem ipsum dolor sit amet, consectetur adipisicing elit. '
                    'Nunc vulputate libero et velit interdum, ac aliquet odio '
                    'mattis. Class aptent taciti sociosqu ad litora torquent '
                    'per conubia nostra, per inceptos himenaeos. Curabitur '
                    'tempus urna at turpis condimentum lobortis. Ut commodo '
                    'efficitur neque. Ut diam quam, semper iaculis condimentum '
                    'ac, vestibulum eu nisl.',
                style: TextStyle(color: Colors.grey, height: 1.5, fontSize: 13),
              ),

              const SizedBox(height: 24),

              // ---- Working Hours ----
              _SectionHeader(title: 'Working Hours', onSeeAll: () {}),
              const SizedBox(height: 12),
              Row(
                children: _hours.map((hour) {
                  final bool selected = hour == _selectedHour;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _SelectableChip(
                      label: hour,
                      selected: selected,
                      onTap: () => setState(() => _selectedHour = hour),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 22),

              // ---- Date ----
              _SectionHeader(title: 'Date', onSeeAll: () {}),
              const SizedBox(height: 12),
              Row(
                children: _days.map((day) {
                  final bool selected = day == _selectedDay;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _SelectableChip(
                      label: day,
                      selected: selected,
                      onTap: () => setState(() => _selectedDay = day),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // ---- Butonul "Book an Appointment" ----
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Programare confirmată: $_selectedDay, $_selectedHour',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryTeal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Book an Appointment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Iconiță rotundă mică (chat/call/video) de lângă numele doctorului
class _RoundIcon extends StatelessWidget {
  final IconData icon;
  const _RoundIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: kPrimaryTeal.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 14, color: kPrimaryTeal),
    );
  }
}

// Chip selectabil folosit pentru ore (Working Hours) și zile (Date)
class _SelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SelectableChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? kPrimaryTeal : const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}