import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
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
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Contactos de Emergencia',
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
                    _buildContactItem('Juan Pérez', '1234567890', Icons.person),
                    _buildContactItem('Ana Gómez', '0987654321', Icons.person),
                    // Añade más contactos aquí
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para añadir contacto
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildContactItem(String name, String phone, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueGrey),
        title: Text(name),
        subtitle: Text('Teléfono: $phone'),
        trailing: IconButton(
          icon: Icon(Icons.message, color: Colors.blueGrey),
          onPressed: () {
            // Lógica para enviar mensaje
          },
        ),
      ),
    );
  }
}
