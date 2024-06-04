class Publicacion {
  final String usuario;
  final String descripcion;
  final String imagen;

  Publicacion({
    required this.usuario,
    required this.descripcion,
    required this.imagen,
  });

  factory Publicacion.fromMap(Map<String, dynamic> data) {
    return Publicacion(
      usuario: data['Usuario'] ?? '',
      descripcion: data['Descripcion'] ?? '',
      imagen: data['Imagen'] ?? '',
    );
  }
}
