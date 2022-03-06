import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sunshine_laundry_driver_app/services/auth_service.dart';
import 'package:sunshine_laundry_driver_app/services/geo_locator_service.dart';
import 'package:sunshine_laundry_driver_app/ui/pages/available_order_screen.dart';
import 'package:sunshine_laundry_driver_app/ui/pages/map_screen.dart';
import 'package:sunshine_laundry_driver_app/ui/pages/messages_screen.dart';
import 'package:sunshine_laundry_driver_app/ui/pages/accepted_order_screen.dart';
import 'package:sunshine_laundry_driver_app/ui/pages/order_history_screen.dart';
import 'package:sunshine_laundry_driver_app/ui/pages/phone_login_screen.dart';
import 'package:sunshine_laundry_driver_app/ui/pages/profile_screen.dart';
import 'package:sunshine_laundry_driver_app/utils/colors.dart';

class DashboardScreen extends StatefulWidget {
  static final routeName = "dashboard-screen";
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    AvailableOrderScreen(),
    AcceptedOrderScreen(),
    OrderHistoryScreen(),
    MapScreen(),
    ProfileScreen()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final locatorService = GeoLocatorService();

  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: (context) => locatorService.getLocation(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                AuthService().signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => PhoneLoginScreen()),
                        (route) => false);
              },
            )
          ],
        ),
        body: _children[_currentIndex], // new
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(ThemeColors.themePrimaryColor),
          unselectedItemColor: Color(ThemeColors.themeSecondaryColor),
          onTap: onTabTapped, // new
          currentIndex: _currentIndex, // new
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Orders'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.done_all),
              title: Text('Accepted'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.history),
              title: Text('History'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text('Map'),
            ),
          ],
        ),
      ),
    );
  }
}
