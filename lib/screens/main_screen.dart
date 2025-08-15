import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class MainScreen extends StatefulWidget {
  final bool isLocationEnabled;
  final Function(bool) onLocationChanged;

  const MainScreen({
    Key? key,
    required this.isLocationEnabled,
    required this.onLocationChanged,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late bool _isLocationEnabled;
  bool _isEmergencyMode = false;
  bool _isSendingAlert = false;
  bool _isPeriodicAlertActive = false;
  int _countdown = 0;
  Timer? _periodicAlertTimer;

  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _isLocationEnabled = widget.isLocationEnabled;
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    _periodicAlertTimer?.cancel();
    super.dispose();
  }

  void _startEmergencyCountdown() {
    setState(() {
      _isSendingAlert = true;
      _countdown = 5;
    });
    _startCountdown();
  }

  void _startCountdown() {
    if (_countdown > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && _isSendingAlert) {
          setState(() {
            _countdown--;
          });
          _startCountdown();
        }
      });
    } else {
      _sendEmergencyAlert();
    }
  }

  void _sendEmergencyAlert() {
    HapticFeedback.heavyImpact();
    setState(() {
      _isSendingAlert = false;
      _isEmergencyMode = true;
    });
    _showAlertSentDialog();
  }

  void _togglePeriodicAlert(bool value) {
    setState(() {
      _isPeriodicAlertActive = value;
      if (_isPeriodicAlertActive) {
        _sendEmergencyAlert();
        _periodicAlertTimer = Timer.periodic(const Duration(minutes: 3), (timer) {
          _sendEmergencyAlert();
        });
      } else {
        _periodicAlertTimer?.cancel();
      }
    });
  }

  void _cancelAlert() {
    setState(() {
      _isSendingAlert = false;
      _countdown = 0;
    });
  }

  void _showAlertSentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade700, size: 30),
              const SizedBox(width: 10),
              const Text('Alerta Enviada'),
            ],
          ),
          content: const Text('Tu alerta de emergencia ha sido enviada exitosamente a todos tus contactos de confianza.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  void _showEmergencyOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EmergencyOptionsSheet(
        onPeriodicAlertToggled: _togglePeriodicAlert,
        isPeriodicAlertActive: _isPeriodicAlertActive,
      ),
    );
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
              _buildHeader(),
              Expanded(
                child: _isSendingAlert ? _buildCountdownView() : _buildMainView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Safe Alert',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    _isLocationEnabled ? Icons.location_on : Icons.location_off,
                    color: _isLocationEnabled ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isLocationEnabled ? 'Ubicación activa' : 'Ubicación desactivada',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _isEmergencyMode ? Colors.red : Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _isEmergencyMode ? 'EMERGENCIA' : 'SEGURO',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: GestureDetector(
                onTap: _startEmergencyCountdown,
                onLongPress: _showEmergencyOptions,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Colors.red,
                        Color(0xFFD32F2F),
                        Color(0xFFB71C1C),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'EMERGENCIA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _isPeriodicAlertActive ? 'ALERTA PERIÓDICA ACTIVA' : 'Toca para activar',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Column(
            children: [
              Text(
                '¿Cómo usar Safe Alert?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              InstructionItem(text: 'Toca el botón para alerta rápida'),
              InstructionItem(text: 'Mantén presionado para más opciones'),
              InstructionItem(text: 'La ubicación se enviará automáticamente'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Enviando alerta en...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
            boxShadow: [
              BoxShadow(
                color: Colors.red,
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$_countdown',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: _cancelAlert,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text(
            'CANCELAR',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class InstructionItem extends StatelessWidget {
  final String text;

  const InstructionItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class EmergencyOptionsSheet extends StatelessWidget {
  final Function(bool) onPeriodicAlertToggled;
  final bool isPeriodicAlertActive;

  const EmergencyOptionsSheet({
    Key? key,
    required this.onPeriodicAlertToggled,
    required this.isPeriodicAlertActive,
  }) : super(key: key);

  final List<EmergencyOption> options = const [
    EmergencyOption('Emergencia Médica', Icons.local_hospital, Colors.red),
    EmergencyOption('Robo/Asalto', Icons.security, Colors.orange),
    EmergencyOption('Violencia', Icons.warning, Colors.purple),
    EmergencyOption('Violencia contra la Mujer', Icons.female, Colors.pink),
    EmergencyOption('Accidente', Icons.car_crash, Colors.blue),
    EmergencyOption('Incendio', Icons.local_fire_department, Colors.deepOrange),
    EmergencyOption('Alerta General', Icons.notifications, Colors.grey),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Tipo de Emergencia',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...options.map((option) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: option.color.withOpacity(0.1),
                  child: Icon(option.icon, color: option.color),
                ),
                title: Text(option.title),
                onTap: () {
                  Navigator.pop(context);
                },
              )),
          const Divider(),
          SwitchListTile(
            title: const Text('Alerta periódica cada 3 minutos'),
            value: isPeriodicAlertActive,
            onChanged: onPeriodicAlertToggled,
            secondary: const Icon(Icons.timer, color: Colors.blue),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class EmergencyOption {
  final String title;
  final IconData icon;
  final Color color;

  const EmergencyOption(this.title, this.icon, this.color);
}
