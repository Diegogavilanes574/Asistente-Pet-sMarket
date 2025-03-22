class RegisterUser {
  final String nombre;
  final String apellido;
  final String direccion;
  final String telefono;
  final String correo;
  final String edad;
  final String sexo;
  final String cedula;
  final String nacionalidad;
  final String password;

  RegisterUser({
    required this.nombre,
    required this.apellido,
    required this.direccion,
    required this.telefono,
    required this.correo,
    required this.edad,
    required this.sexo,
    required this.cedula,
    required this.nacionalidad,
    required this.password,
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) {
    return RegisterUser(
      nombre: json['nombre'],
      apellido: json['apellido'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      correo: json['correo'],
      edad: json['edad'],
      sexo: json['sexo'],
      cedula: json['cedula'],
      nacionalidad: json['nacionalidad'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'direccion': direccion,
      'telefono': telefono,
      'correo': correo,
      'edad': edad,
      'sexo': sexo,
      'cedula': cedula,
      'nacionalidad': nacionalidad,
      'password': password,
    };
  }
}
