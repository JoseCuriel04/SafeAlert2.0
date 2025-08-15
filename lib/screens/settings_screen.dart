import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final bool isLocationEnabled;
  final Function(bool) onLocationChanged;

  const SettingsScreen({
    Key? key,
    required this.isLocationEnabled,
    required this.onLocationChanged,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _notificationsEnabled;
  late bool _locationEnabled;
  bool _darkThemeEnabled = false;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = true;
    _locationEnabled = widget.isLocationEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
              Color(0xFF60A5FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Configuración',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildSettingSwitch(
                        'Notificaciones Push', _notificationsEnabled, (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    }),
                    _buildSettingSwitch(
                        'Permisos de Ubicación', _locationEnabled, (value) {
                      setState(() {
                        _locationEnabled = value;
                      });
                      widget.onLocationChanged(value);
                    }),
                    _buildSettingSwitch('Tema Oscuro', _darkThemeEnabled, (value) {
                      setState(() {
                        _darkThemeEnabled = value;
                      });
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingSwitch(String title, bool value, Function(bool) onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SwitchListTile(
        title: Text(title),
        value: value,
        onChanged: onChanged,
        secondary: Icon(
          title == 'Tema Oscuro'
              ? Icons.brightness_2
              : title == 'Notificaciones Push'
                  ? Icons.notifications
                  : Icons.location_on,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
