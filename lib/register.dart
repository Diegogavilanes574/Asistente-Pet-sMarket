import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_application_1/locator.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:flutter_application_1/services/user_service.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http; // Añadimos el paquete http
import 'dart:convert'; // Para manejar JSON

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _cedulaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();
  final _edadController = TextEditingController();
  final _nacionalidadController = TextEditingController();
  String? _selectedSexo;
  bool _passwordVisible = false;
  bool _repasswordVisible = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasMinLength = false;
  DateTime? _fechaNacimiento;
  int? _edad;

  final List<String> _sexoOptions = ['MASCULINO', 'FEMENINO', 'NO DEFINIDO'];

  String? _validateCedula(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obligatorio';
    }
    if (value.length != 10) {
      return 'La cédula debe tener 10 dígitos';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'La cédula debe contener solo números';
    }
    
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      int digit = int.parse(value[i]);
      if (i % 2 == 0) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
    }
    int lastDigit = int.parse(value[9]);
    int verifier = (10 - (sum % 10)) % 10;
    if (verifier != lastDigit) {
      return 'Cédula inválida';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obligatorio';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingrese un correo válido';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obligatorio';
    }
    if (!RegExp(r'^09[0-9]{8}$').hasMatch(value)) {
      return 'Ingrese un número válido (ej: 09XXXXXXXX)';
    }
    return null;
  }

  String? _validateEdad(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obligatorio';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'La edad debe contener solo números';
    }
    int edad = int.tryParse(value) ?? 0;
    if (edad < 0 || edad > 120) {
      return 'Edad inválida';
    }
    return null;
  }

  void _validatePassword(String password) {
    setState(() {
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasMinLength = password.length >= 6;
    });
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, [
    TextInputType? keyboardType,
    bool obscureText = false,
    bool isPassword = false,
    bool isRePassword = false,
    List<TextInputFormatter>? inputFormatters,
  ]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword ? !_passwordVisible : isRePassword ? !_repasswordVisible : obscureText,
        onChanged: isPassword ? (value) => _validatePassword(value) : null,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          suffixIcon: isPassword || isRePassword
              ? IconButton(
                  icon: Icon(
                    (isPassword ? _passwordVisible : _repasswordVisible)
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isPassword) {
                        _passwordVisible = !_passwordVisible;
                      } else {
                        _repasswordVisible = !_repasswordVisible;
                      }
                    });
                  },
                )
              : null,
        ),
        style: const TextStyle(color: Colors.black),
        validator: (value) {
          if (controller == _cedulaController) {
            return _validateCedula(value);
          }
          if (controller == _correoController) {
            return _validateEmail(value);
          }
          if (controller == _telefonoController) {
            return _validatePhone(value);
          }
          if (controller == _edadController) {
            return _validateEdad(value);
          }
          if (value == null || value.isEmpty) {
            return 'Campo obligatorio';
          }
          if (isPassword && !_hasMinLength) {
            return 'La contraseña debe tener al menos 6 caracteres';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordCriteria() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(_hasUppercase ? Icons.check_circle : Icons.cancel, color: _hasUppercase ? Colors.green : Colors.red),
            const SizedBox(width: 8),
            const Text('Debe contener al menos una letra mayúscula', style: TextStyle(color: Colors.black)),
          ],
        ),
        Row(
          children: [
            Icon(_hasNumber ? Icons.check_circle : Icons.cancel, color: _hasNumber ? Colors.green : Colors.red),
            const SizedBox(width: 8),
            const Text('Debe contener al menos un número', style: TextStyle(color: Colors.black)),
          ],
        ),
        Row(
          children: [
            Icon(_hasMinLength ? Icons.check_circle : Icons.cancel, color: _hasMinLength ? Colors.green : Colors.red),
            const SizedBox(width: 8),
            const Text('Debe tener al menos 6 caracteres', style: TextStyle(color: Colors.black)),
          ],
        ),
      ],
    );
  }

  Widget _buildSexoDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Sexo',
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        value: _selectedSexo,
        hint: const Text('Seleccione una opción'),
        items: _sexoOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedSexo = newValue;
          });
        },
        validator: (value) => value == null ? 'Campo obligatorio' : null,
      ),
    );
  }

  Future<void> _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text == _repasswordController.text) {
        // Validar criterios de contraseña
        if (!_hasUppercase || !_hasNumber || !_hasMinLength) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('La contraseña debe cumplir con todos los criterios')),
          );
          return;
        }

        // URL de la API en el host
        final url = Uri.parse('https://petsmarket.backupti.com/docs/api/register.php');
        try {
          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'nombre': _nombreController.text,
              'apellido': _apellidosController.text,
              'direccion': _direccionController.text,
              'telefono': _telefonoController.text,
              'correo': _correoController.text,
              'edad': int.parse(_edadController.text), // Convertimos a entero
              'sexo': _selectedSexo,
              'cedula': _cedulaController.text,
              'nacionalidad': _nacionalidadController.text,
              'clave': _passwordController.text,
            }),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data['status'] == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('¡Felicidades! Se pudo registrar.')),
              );
              Beamer.of(context).beamToNamed('/login');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(data['message'] ?? 'Error al registrar')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error en la solicitud: ${response.statusCode}')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error de conexión: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  margin: const EdgeInsets.symmetric(horizontal: 32.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF1976D2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Registro',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                _buildTextField(
                  _cedulaController,
                  'Cédula',
                  TextInputType.number,
                  false,
                  false,
                  false,
                  [FilteringTextInputFormatter.digitsOnly],
                ),
                _buildTextField(_nombreController, 'Nombre'),
                _buildTextField(_apellidosController, 'Apellidos'),
                _buildTextField(_correoController, 'Correo Electrónico', TextInputType.emailAddress),
                _buildTextField(
                  _telefonoController,
                  'Teléfono',
                  TextInputType.phone,
                  false,
                  false,
                  false,
                  [FilteringTextInputFormatter.digitsOnly],
                ),
                _buildTextField(_direccionController, 'Dirección'),
                _buildTextField(
                  _edadController,
                  'Edad',
                  TextInputType.number,
                  false,
                  false,
                  false,
                  [FilteringTextInputFormatter.digitsOnly],
                ),
                _buildSexoDropdown(),
                _buildTextField(_nacionalidadController, 'Nacionalidad', TextInputType.text),
                _buildTextField(_passwordController, 'Contraseña', null, true, true),
                _buildPasswordCriteria(),
                _buildTextField(_repasswordController, 'Repetir Contraseña', null, true, false, true),
                ElevatedButton(
                  onPressed: () async {
                    await _registrarUsuario();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1976D2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Registrarse', style: TextStyle(fontSize: 18, color: Color(0xFF1976D2))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _nombreController.dispose();
    _apellidosController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
    _edadController.dispose();
    _nacionalidadController.dispose();
    super.dispose();
  }
}