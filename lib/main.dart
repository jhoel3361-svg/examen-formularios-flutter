
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Examen de Formularios',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const MenuPrincipal(),
    );
  }
}

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    final ejercicios = [
      ['Ejercicio 1', 'Formulario de nombres'],
      ['Ejercicio 2', 'Correo electrónico'],
      ['Ejercicio 3', 'Registro de edad'],
      ['Ejercicio 4', 'Registro de DNI'],
      ['Ejercicio 5', 'Registro de contraseña'],
      ['Ejercicio 6', 'Formulario de estudiante'],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('EXAMEN FLUTTER'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'FORMULARIOS Y VALIDACIONES',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < ejercicios.length; i++)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${i + 1}'),
                ),
                title: Text(ejercicios[i][0]),
                subtitle: Text(ejercicios[i][1]),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Formulario(
                        numero: i + 1,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class Campo {
  final String nombre;
  final String etiqueta;
  final String? Function(String) validar;
  final TextInputType teclado;
  final bool ocultar;

  Campo({
    required this.nombre,
    required this.etiqueta,
    required this.validar,
    this.teclado = TextInputType.text,
    this.ocultar = false,
  });
}

class Formulario extends StatefulWidget {
  final int numero;

  const Formulario({super.key, required this.numero});

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final _formKey = GlobalKey<FormState>();

  late List<Campo> campos;

  String mensajeExito = 'Registro exitoso';

  @override
  void initState() {
    super.initState();
    campos = obtenerCampos(widget.numero);
  }

  List<Campo> obtenerCampos(int numero) {
    switch (numero) {
      case 1:
        return [
          Campo(
            nombre: 'Nombre',
            etiqueta: 'Ingrese su nombre',
            validar: (v) =>
                v.trim().isEmpty ? 'Ingrese su nombre' : null,
          ),
        ];

      case 2:
        mensajeExito = 'Correo registrado correctamente';
        return [
          Campo(
            nombre: 'Correo',
            etiqueta: 'Ingrese su correo',
            teclado: TextInputType.emailAddress,
            validar: (v) =>
                v.trim().isEmpty || !v.contains('@')
                    ? 'Ingrese un correo válido'
                    : null,
          ),
        ];

      case 3:
        mensajeExito = 'Edad registrada correctamente';
        return [
          Campo(
            nombre: 'Edad',
            etiqueta: 'Ingrese su edad',
            teclado: TextInputType.number,
            validar: (v) {
              final edad = int.tryParse(v);
              if (v.trim().isEmpty) return 'Ingrese su edad';
              if (edad == null) return 'Solo se aceptan números';
              if (edad < 18) return 'Debe ser mayor o igual a 18';
              return null;
            },
          ),
        ];

      case 4:
        mensajeExito = 'DNI registrado correctamente';
        return [
          Campo(
            nombre: 'DNI',
            etiqueta: 'Ingrese su DNI',
            teclado: TextInputType.number,
            validar: (v) =>
                RegExp(r'^\d{8}$').hasMatch(v)
                    ? null
                    : 'DNI incorrecto',
          ),
        ];

      case 5:
        mensajeExito = 'Contraseña registrada correctamente';
        return [
          Campo(
            nombre: 'Contraseña',
            etiqueta: 'Ingrese su contraseña',
            ocultar: true,
            validar: (v) => v.isEmpty
                ? 'Ingrese su contraseña'
                : v.length < 6
                    ? 'La contraseña debe tener al menos 6 caracteres'
                    : null,
          ),
        ];

      default:
        mensajeExito = 'Estudiante registrado correctamente';
        return [
          Campo(
            nombre: 'Nombre',
            etiqueta: 'Ingrese el nombre',
            validar: (v) =>
                v.trim().isEmpty ? 'Ingrese el nombre' : null,
          ),
          Campo(
            nombre: 'Apellidos',
            etiqueta: 'Ingrese los apellidos',
            validar: (v) =>
                v.trim().isEmpty ? 'Ingrese los apellidos' : null,
          ),
          Campo(
            nombre: 'Edad',
            etiqueta: 'Ingrese la edad',
            teclado: TextInputType.number,
            validar: (v) {
              if (v.trim().isEmpty) return 'Ingrese la edad';
              if (int.tryParse(v) == null) return 'Solo números';
              return null;
            },
          ),
          Campo(
            nombre: 'Correo',
            etiqueta: 'Ingrese el correo',
            teclado: TextInputType.emailAddress,
            validar: (v) =>
                v.trim().isEmpty || !v.contains('@')
                    ? 'Ingrese un correo válido'
                    : null,
          ),
        ];
    }
  }

  void registrar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensajeExito),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicio ${widget.numero}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.numero == 6
                    ? 'FORMULARIO DE ESTUDIANTE'
                    : campos.first.nombre.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),

              for (final campo in campos) ...[
                TextFormField(
                  keyboardType: campo.teclado,
                  obscureText: campo.ocultar,
                  decoration: InputDecoration(
                    labelText: campo.etiqueta,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.edit),
                  ),
                  validator: campo.validar,
                ),
                const SizedBox(height: 20),
              ],

              ElevatedButton(
                onPressed: registrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'REGISTRAR',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 15),

              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('VOLVER AL MENÚ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
