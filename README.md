# 📱 App de Seguridad Personal con Botón de Pánico

## 🚀 Descripción del Proyecto

Aplicación móvil desarrollada en Flutter que permite al usuario enviar una alerta de emergencia con su ubicación en tiempo real a sus contactos de confianza mediante notificaciones push o correo electrónico.

---

## 🎯 Objetivo

Facilitar la localización y asistencia inmediata a personas que se encuentren en situaciones de riesgo o emergencia, mediante un botón de pánico accesible y fácil de usar.

---

## 🛠️ Tecnologías Utilizadas

- **Flutter:** Framework multiplataforma para desarrollo móvil.
- **Firebase:**
  - Realtime Database o Firestore (almacenamiento de datos).
  - Firebase Cloud Messaging (notificaciones push).
  - Firebase Functions (envío de correos electrónicos).
- **Sensor:**
  - GPS del dispositivo (captura de ubicación).

---

## 🗃️ Modelo de Datos (Tablas)

### Usuarios
- `id`: Identificador único.
- `nombre`: Nombre completo.
- `teléfono`: Número de teléfono.
- `email`: Correo electrónico.

### ContactosEmergencia
- `id`: Identificador único del contacto.
- `idUsuario`: Relación con la tabla Usuarios.
- `nombre`: Nombre del contacto.
- `teléfono`: Teléfono del contacto.
- `email`: Correo electrónico del contacto.

### Alertas
- `id`: Identificador único de la alerta.
- `idUsuario`: Relación con la tabla Usuarios.
- `latitud`: Latitud de la ubicación.
- `longitud`: Longitud de la ubicación.
- `fechaHora`: Fecha y hora de la alerta.

---

## 🖼️ Wireframes / Mockups

- **Pantalla Principal:**
  - Botón grande "ENVIAR ALERTA".
  - Indicador de GPS activo.
  - Navegación: Inicio, Contactos, Historial, Configuración.

- **Pantalla de Contactos:**
  - Lista de contactos de emergencia.
  - Botón "Añadir Contacto".

- **Pantalla de Historial:**
  - Lista de alertas enviadas.
  - Opción de visualizar ubicación en el mapa.

- **Pantalla de Configuración:**
  - Selección de métodos de envío.
  - Permisos de ubicación y notificaciones.

*(Las imágenes de wireframes se encuentran en la carpeta `/assets/mockups`.)*

---

## ✅ Requerimientos Cubiertos

- Uso de base de datos remota.
- Mínimo 3 tablas.
- Al menos un servicio (notificaciones push o correo).
- Al menos un sensor (GPS).

---

## 📂 Instalación y Ejecución

1. Clonar el repositorio:

   ```bash
   git clone https://github.com/JoseCuriel04/SafeAlert2.0.git
