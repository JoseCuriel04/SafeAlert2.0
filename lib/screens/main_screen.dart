import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {

@override

_MainScreenState createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {

bool _isEmergencyMode = false;

bool _isLocationEnabled = true;

bool _isSendingAlert = false;

int _countdown = 0;

late AnimationController _pulseController;

late AnimationController _shakeController;

late Animation<double> _pulseAnimation;

late Animation<double> _shakeAnimation;

@override

void initState() {

super.initState();

_pulseController = AnimationController(

duration: Duration(milliseconds: 1000),

vsync: this,

)..repeat(reverse: true);



_shakeController = AnimationController(

duration: Duration(milliseconds: 500),

vsync: this,

);



_pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(

CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut)

);



_shakeAnimation = Tween<double>(begin: 0, end: 10).animate(

CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn)

);

}

@override

void dispose() {

_pulseController.dispose();

_shakeController.dispose();

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

Future.delayed(Duration(seconds: 1), () {

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

// Aquí iría la lógica real de envío

HapticFeedback.heavyImpact();

setState(() {

_isSendingAlert = false;

});



_showAlertSentDialog();

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

Icon(Icons.check_circle, color: Colors.green, size: 30),

SizedBox(width: 10),

Text('Alerta Enviada'),

],

),

content: Text('Tu alerta de emergencia ha sido enviada exitosamente a todos tus contactos de confianza.'),

actions: [

TextButton(

onPressed: () => Navigator.of(context).pop(),

child: Text('Entendido'),

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

builder: (context) => EmergencyOptionsSheet(),

);

}

@override

Widget build(BuildContext context) {

return Scaffold(

body: Container(

decoration: BoxDecoration(

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

// Header con estado

_buildHeader(),



// Área principal

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

padding: EdgeInsets.all(20),

child: Row(

mainAxisAlignment: MainAxisAlignment.spaceBetween,

children: [

Column(

crossAxisAlignment: CrossAxisAlignment.start,

children: [

Text(

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

SizedBox(width: 4),

Text(

_isLocationEnabled ? 'Ubicación activa' : 'Ubicación desactivada',

style: TextStyle(

color: Colors.white70,

fontSize: 12,

),

),

],

),

],

),

Container(

padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),

decoration: BoxDecoration(

color: _isEmergencyMode ? Colors.red : Colors.green,

borderRadius: BorderRadius.circular(20),

),

child: Text(

_isEmergencyMode ? 'EMERGENCIA' : 'SEGURO',

style: TextStyle(

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

// Botón principal de emergencia

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

gradient: RadialGradient(

colors: [

Colors.red.shade400,

Colors.red.shade600,

Colors.red.shade800,

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

Icon(

Icons.warning,

color: Colors.white,

size: 40,

),

SizedBox(height: 8),

Text(

'EMERGENCIA',

style: TextStyle(

color: Colors.white,

fontSize: 18,

fontWeight: FontWeight.bold,

),

),

Text(

'Toca para activar',

style: TextStyle(

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



SizedBox(height: 40),



// Instrucciones

Container(

margin: EdgeInsets.symmetric(horizontal: 40),

padding: EdgeInsets.all(20),

decoration: BoxDecoration(

color: Colors.white.withOpacity(0.1),

borderRadius: BorderRadius.circular(15),

),

child: Column(

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

_buildInstructionItem('Toca el botón para alerta rápida'),

_buildInstructionItem('Mantén presionado para más opciones'),

_buildInstructionItem('La ubicación se enviará automáticamente'),

],

),

),

],

);

}

Widget _buildInstructionItem(String text) {

return Padding(

padding: EdgeInsets.symmetric(vertical: 2),

child: Row(

children: [

Icon(Icons.check_circle_outline, color: Colors.white70, size: 16),

SizedBox(width: 8),

Expanded(

child: Text(

text,

style: TextStyle(color: Colors.white70, fontSize: 12),

),

),

],

),

);

}

Widget _buildCountdownView() {

return Column(

mainAxisAlignment: MainAxisAlignment.center,

children: [

Text(

'Enviando alerta en...',

style: TextStyle(

color: Colors.white,

fontSize: 20,

fontWeight: FontWeight.bold,

),

),

SizedBox(height: 30),

Container(

width: 150,

height: 150,

decoration: BoxDecoration(

shape: BoxShape.circle,

color: Colors.red,

boxShadow: [

BoxShadow(

color: Colors.red.withOpacity(0.5),

blurRadius: 20,

spreadRadius: 5,

),

],

),

child: Center(

child: Text(

'$_countdown',

style: TextStyle(

color: Colors.white,

fontSize: 60,

fontWeight: FontWeight.bold,

),

),

),

),

SizedBox(height: 40),

ElevatedButton(

onPressed: _cancelAlert,

style: ElevatedButton.styleFrom(

backgroundColor: Colors.white,

foregroundColor: Colors.red,

padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),

shape: RoundedRectangleBorder(

borderRadius: BorderRadius.circular(25),

),

),

child: Text(

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

class EmergencyOptionsSheet extends StatelessWidget {

final List<EmergencyOption> options = [

EmergencyOption('Emergencia Médica', Icons.local_hospital, Colors.red),

EmergencyOption('Robo/Asalto', Icons.security, Colors.orange),

EmergencyOption('Violencia', Icons.warning, Colors.purple),

EmergencyOption('Accidente', Icons.car_crash, Colors.blue),

EmergencyOption('Incendio', Icons.local_fire_department, Colors.deepOrange),

EmergencyOption('Alerta General', Icons.notifications, Colors.grey),

];

@override

Widget build(BuildContext context) {

return Container(

decoration: BoxDecoration(

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

margin: EdgeInsets.only(top: 10),

width: 40,

height: 4,

decoration: BoxDecoration(

color: Colors.grey[300],

borderRadius: BorderRadius.circular(2),

),

),

Padding(

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

// Enviar alerta específica

},

)),

SizedBox(height: 20),

],

),

);

}

}

class EmergencyOption {

final String title;

final IconData icon;

final Color color;

EmergencyOption(this.title, this.icon, this.color);

}
