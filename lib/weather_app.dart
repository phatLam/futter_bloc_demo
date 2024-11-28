import 'package:demo2/weather/cubit/weather_cubit.dart';
import 'package:demo2/weather/view/weather_page.dart';
import 'package:demo2/weather/widget/weather_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello/l10n/app_localizations.dart';
import 'package:weather_repo/weather_repo.dart';

import 'generated/l10n.dart';
import 'setting/setting_page.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key, required WeatherRepo weatherRepo})
  : _weatherRepo = weatherRepo;

  final WeatherRepo _weatherRepo;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<WeatherCubit>(
      create: (context) => WeatherCubit(_weatherRepo),
      child: const WeatherAppView(),
    );
  }
}

class WeatherAppView extends StatelessWidget {
  const WeatherAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        textTheme: GoogleFonts.rajdhaniTextTheme(),
      ),
      routes: {
        '/settings': (context) => const SettingPage(),
      },
      home: const WeatherPage(),
    );
  }
}
