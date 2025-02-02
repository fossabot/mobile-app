import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:inkstep/blocs/journeys_bloc.dart';
import 'package:inkstep/blocs/simple_bloc_delegate.dart';
import 'package:inkstep/di/service_locator.dart';
import 'package:inkstep/resources/journeys_repository.dart';
import 'package:inkstep/resources/web_repository.dart';
import 'package:inkstep/ui/pages/onboarding.dart';

void main() {
  // Set up error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.context.contains('layout')) {
      print('RENDERING ERROR:');
    }
    print(details.exception);
  };

  // Set up BlocSupervisor
  BlocSupervisor.delegate = SimpleBlocDelegate();

  // Set up Service Locator
  setup();

  runApp(Inkstep());
}

var hintStyle = TextStyle(color: baseColors['gray']);

const baseColors = ColorSwatch<String>(0xFF0A0D18, {
  'dark': Color(0xFF313639),
  'gray': Color(0xFF6b7080),
  'light': Color(0xFFFFFFFF),
  'error': Color(0xFFFF0000)
});

class Inkstep extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InkstepState();
}

class InkstepState extends State<Inkstep> {
  http.Client client;
  JourneysBloc _journeyBloc;

  @override
  void initState() {
    client = http.Client();
    _journeyBloc = JourneysBloc(
      journeysRepository: JourneysRepository(webClient: WebRepository(client: client)),
    );
    super.initState();
  }

  @override
  void dispose() {
    client.close();
    _journeyBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return BlocProvider<JourneysBloc>(
      child: MaterialApp(
        title: 'inkstep',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.deepPurple,
          primaryColor: baseColors['dark'],
          backgroundColor: baseColors['dark'],
          cardColor: baseColors['light'],
          cardTheme: CardTheme(
            color: baseColors['light'],
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          textTheme: _getTextWithColor(baseColors['light']),
          accentTextTheme: _getTextWithColor(baseColors['dark']),
          iconTheme: _getIconWithColor(baseColors['light']),
          accentIconTheme: _getIconWithColor(baseColors['dark']),
          buttonTheme: ButtonThemeData(
            buttonColor: baseColors['dark'],
          ),
          cursorColor: baseColors['dark'],
          toggleableActiveColor: baseColors['dark'],
        ),
        home: Onboarding(),
      ),
      bloc: _journeyBloc,
    );
  }

  TextTheme _getTextWithColor(Color color) => TextTheme(
      headline: TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      title: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      subhead: TextStyle(
        fontSize: 20.0,
        color: color,
      ),
      body1: TextStyle(
        fontSize: 18.0,
        color: color,
      ),
      subtitle: TextStyle(
        fontSize: 20.0,
        color: color,
        fontWeight: FontWeight.w500,
      ),
      caption: TextStyle(
        fontSize: 12.0,
        color: color,
        fontWeight: FontWeight.w400,
      ));

  IconThemeData _getIconWithColor(Color color) => IconThemeData(
        color: color,
      );
}
