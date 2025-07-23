import 'package:flutter/material.dart';

import 'screens/main_screen.dart';

import 'screens/contacts_screen.dart';

import 'screens/history_screen.dart';

import 'screens/settings_screen.dart';

void main() {

runApp(MyApp());

}

class MyApp extends StatelessWidget {

@override

Widget build(BuildContext context) {

return MaterialApp(

title: 'SafeGuard',

debugShowCheckedModeBanner: false,

theme: ThemeData(

// Tema moderno con colores de seguridad

primarySwatch: Colors.blue,

primaryColor: const Color(0xFF1E3A8A), // Azul profundo

colorScheme: ColorScheme.fromSeed(

seedColor: const Color(0xFF1E3A8A),

brightness: Brightness.light,

),

scaffoldBackgroundColor: const Color(0xFFF8FAFC),

appBarTheme: const AppBarTheme(

backgroundColor: Color(0xFF1E3A8A),

foregroundColor: Colors.white,

elevation: 0,

),

// Tipografía mejorada

textTheme: const TextTheme(

headlineLarge: TextStyle(

fontSize: 28,

fontWeight: FontWeight.bold,

color: Color(0xFF1E293B),

),

headlineMedium: TextStyle(

fontSize: 22,

fontWeight: FontWeight.w600,

color: Color(0xFF334155),

),

bodyLarge: TextStyle(

fontSize: 16,

color: Color(0xFF475569),

),

),

// Botones con estilo moderno

elevatedButtonTheme: ElevatedButtonThemeData(

style: ElevatedButton.styleFrom(

backgroundColor: const Color(0xFF1E3A8A),

foregroundColor: Colors.white,

shape: RoundedRectangleBorder(

borderRadius: BorderRadius.circular(12),

),

padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),

),

),

),

home: MainAppScreen(),

);

}

}

class MainAppScreen extends StatefulWidget {

@override

_MainAppScreenState createState() => _MainAppScreenState();

}

class _MainAppScreenState extends State<MainAppScreen> with TickerProviderStateMixin {

int _currentIndex = 0;

late AnimationController _animationController;

late Animation<double> _fadeAnimation;

final List<Widget> _screens = [

MainScreen(),

ContactsScreen(),

HistoryScreen(),

SettingsScreen(),

];

final List<NavigationItem> _navigationItems = [

NavigationItem(

icon: Icons.shield_outlined,

activeIcon: Icons.shield,

label: 'Protección',

color: const Color(0xFF10B981), // Verde para seguridad

),

NavigationItem(

icon: Icons.contacts_outlined,

activeIcon: Icons.contacts,

label: 'Contactos',

color: const Color(0xFF3B82F6), // Azul

),

NavigationItem(

icon: Icons.history_outlined,

activeIcon: Icons.history,

label: 'Historial',

color: const Color(0xFF8B5CF6), // Púrpura

),

NavigationItem(

icon: Icons.settings_outlined,

activeIcon: Icons.settings,

label: 'Ajustes',

color: const Color(0xFF64748B), // Gris

),

];

@override

void initState() {

super.initState();

_animationController = AnimationController(

duration: const Duration(milliseconds: 300),

vsync: this,

);

_fadeAnimation = Tween<double>(

begin: 0.0,

end: 1.0,

).animate(CurvedAnimation(

parent: _animationController,

curve: Curves.easeInOut,

));

_animationController.forward();

}

@override

void dispose() {

_animationController.dispose();

super.dispose();

}

@override

Widget build(BuildContext context) {

return Scaffold(

body: AnimatedSwitcher(

duration: const Duration(milliseconds: 300),

child: Container(

key: ValueKey(_currentIndex),

child: _screens[_currentIndex],

),

),

bottomNavigationBar: Container(

decoration: BoxDecoration(

color: Colors.white,

boxShadow: [

BoxShadow(

color: Colors.black.withOpacity(0.1),

blurRadius: 20,

offset: const Offset(0, -5),

),

],

),

child: SafeArea(

child: Padding(

padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

child: Row(

mainAxisAlignment: MainAxisAlignment.spaceAround,

children: List.generate(_navigationItems.length, (index) {

final item = _navigationItems[index];

final isSelected = _currentIndex == index;



return GestureDetector(

onTap: () {

setState(() {

_currentIndex = index;

});

_animationController.reset();

_animationController.forward();

},

child: AnimatedContainer(

duration: const Duration(milliseconds: 200),

padding: const EdgeInsets.symmetric(

horizontal: 16,

vertical: 8,

),

decoration: BoxDecoration(

color: isSelected

? item.color.withOpacity(0.1)

: Colors.transparent,

borderRadius: BorderRadius.circular(12),

),

child: Column(

mainAxisSize: MainAxisSize.min,

children: [

AnimatedSwitcher(

duration: const Duration(milliseconds: 200),

child: Icon(

isSelected ? item.activeIcon : item.icon,

key: ValueKey(isSelected),

color: isSelected ? item.color : Colors.grey[600],

size: 24,

),

),

const SizedBox(height: 4),

AnimatedDefaultTextStyle(

duration: const Duration(milliseconds: 200),

style: TextStyle(

fontSize: 12,

fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,

color: isSelected ? item.color : Colors.grey[600],

),

child: Text(item.label),

),

],

),

),

);

}),

),

),

),

),

);

}

}

class NavigationItem {

final IconData icon;

final IconData activeIcon;

final String label;

final Color color;

NavigationItem({

required this.icon,

required this.activeIcon,

required this.label,

required this.color,

});

}