import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app_colors.dart';
import 'data/repositories/medical_repository.dart';
import 'logic/home/home_cubit.dart';
import 'presentation/screens/home_screen.dart';

class MedicalApp extends StatelessWidget {
  final MedicalRepository? repository;

  const MedicalApp({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    // Repository-ul și HomeCubit sunt disponibile în toate ecranele
    return RepositoryProvider(
      create: (_) => repository ?? MedicalRepository(),
      child: BlocProvider(
        create: (context) =>
            HomeCubit(context.read<MedicalRepository>())..loadData(),
        child: MaterialApp(
          title: 'Medical App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.background,
            fontFamily: 'Roboto',
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
