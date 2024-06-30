import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'pages/history_page.dart';
import 'pages/income/income_page.dart';
import 'pages/outcome/outcome_page.dart';
import 'pages/auth/login.dart';
import 'tabItem.dart';
import 'bottomNavigation.dart';
import 'screens.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  static int currentTab = 0;

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  final List<TabItem> tabs = [
    TabItem(
      tabName: "Home",
      icon: Icons.home,
      page: HomeScreen(),
    ),
    TabItem(
      tabName: "Income",
      icon: Icons.event_busy_rounded,
      page: IncomePage(userId: ''),  // Placeholder, will be set later
    ),
    TabItem(
      tabName: "Outcome",
      icon: Icons.event_busy_rounded,
      page: HomeScreen(),
    ),
    TabItem(
      tabName: "History",
      icon: Icons.history,
      page: HomeScreen(),
    ),
  ];

  bool _isAuthenticated = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    print('initState called'); // Add this line
    _checkLoginStatus();
  }


  Future<void> _checkLoginStatus() async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      final userId = await _storage.read(key: 'userId');
      print('AccessToken: $accessToken, UserId: $userId'); // Add this line
      setState(() {
        _isAuthenticated = accessToken != null && userId != null;
        _userId = userId;
      });

      if (_isAuthenticated) {
        tabs[1] = TabItem(
          tabName: "Income",
          icon: Icons.event_busy_rounded,
          page: IncomePage(userId: _userId!),  // Set userId dynamically
        );
      }
    } catch (e) {
      print('Error reading from secure storage: $e'); // Add this line
      setState(() {
        _isAuthenticated = false;
      });
    }
  }

  void _selectTab(int index) {
    if (index == currentTab) {
      if (tabs[index].key.currentState != null) {
        tabs[index].key.currentState!.popUntil((route) => route.isFirst);
      }
    } else {
      setState(() => currentTab = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('isAuthenticated: $_isAuthenticated'); // Add this line
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !(await tabs[currentTab].key.currentState?.maybePop() ?? false);
        if (isFirstRouteInCurrentTab) {
          if (currentTab != 0) {
            _selectTab(0);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: _isAuthenticated
            ? IndexedStack(
          index: currentTab,
          children: tabs.map((e) => e.page).toList(),
        )
            : LoginPage(),  // Redirect to login if not authenticated
        bottomNavigationBar: _isAuthenticated
            ? BottomNavigation(
          onSelectTab: _selectTab,
          tabs: tabs,
        )
            : null,  // Hide bottom navigation if not authenticated
      ),
    );
  }
}