import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alarm_care_pro/screens/ventilator_screen.dart';
import 'package:alarm_care_pro/screens/pumps_screen.dart';
import 'package:alarm_care_pro/screens/monitor_screen.dart';
import 'package:alarm_care_pro/screens/dashboard_screen.dart';
import 'package:alarm_care_pro/screens/login_screen.dart';
import 'package:alarm_care_pro/services/socket_service.dart';
import 'package:alarm_care_pro/providers/patient_vitals_provider.dart';
import 'package:alarm_care_pro/providers/ventilator_provider.dart';
import 'package:alarm_care_pro/providers/infusion_pump_provider.dart';
import 'package:alarm_care_pro/providers/auth_provider.dart';
import 'package:alarm_care_pro/providers/settings_provider.dart';
import 'package:alarm_care_pro/screens/settings_screen.dart';

void main() {
  runApp(const AlarmCareProApp());
}

class AlarmCareProApp extends StatelessWidget {
  const AlarmCareProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => PatientVitalsProvider()),
        ChangeNotifierProvider(create: (_) => VentilatorProvider()),
        ChangeNotifierProvider(create: (_) => InfusionPumpProvider()),
      ],
      child: Consumer2<AuthProvider, SettingsProvider>(
        builder: (context, auth, settings, _) {
          return MaterialApp(
            title: 'AlarmCare Pro',
            theme: settings.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: auth.isLoading
                ? const Scaffold(body: Center(child: CircularProgressIndicator()))
                : auth.isAuthenticated
                    ? const MainScreen()
                    : const LoginScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isExpanded = false;
  final SocketService _socketService = SocketService();

  @override
  void initState() {
    super.initState();
    _socketService.connect(context);
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    VentilatorScreen(),
    PumpsScreen(),
    MonitorScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            extended: _isExpanded,
            leading: IconButton(
              icon: Icon(_isExpanded ? Icons.chevron_left : Icons.chevron_right),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.air),
                label: Text('Ventilador'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.local_drink),
                label: Text('Bombas'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.monitor_heart),
                label: Text('Monitor'),
              ),
            ],
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          Provider.of<AuthProvider>(context, listen: false).logout();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
