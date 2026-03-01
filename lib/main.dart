import 'package:businesscardapp/core/theme/app_theme.dart';
import 'package:businesscardapp/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:businesscardapp/features/scan/presentation/pages/scan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'features/scan/scan_provider.dart';
import 'features/dashboard/dashboard_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: GetMaterialApp(
        title: 'AI Business Card Scanner',
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        theme: AppTheme.lightTheme,
        home: const MainScreen(),
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
  int _currentIndex = 0;
  DateTime? _lastPressedAt; // ← for double back detection

  final List<Widget> _pages = const [ScanPage(), DashboardPage()];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // ← important: we control the back behavior
      onPopInvoked: (didPop) async {
        if (didPop) return; // already handled by system

        final now = DateTime.now();
        const exitTime = Duration(seconds: 2);

        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > exitTime) {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(milliseconds: 300),
            ),
          );
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey[600],
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined),
              activeIcon: Icon(Icons.camera_alt),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts_outlined),
              activeIcon: Icon(Icons.contacts),
              label: 'Contacts',
            ),
          ],
        ),
      ),
    );
  }
}
