class Publicacion {
  final String Usuario;
  final String Descripcion;
  final String Imagen;
  final String? Video; 

  Publicacion({
    required this.Usuario,
    required this.Descripcion,
    required this.Imagen,
    this.Video, 
  });

  factory Publicacion.fromMap(Map<String, dynamic> data) {
    return Publicacion(
      Usuario: data['Usuario'] ?? '',
      Descripcion: data['Descripcion'] ?? '',
      Imagen: data['Imagen'] ?? '',
      Video: data['Video'] ?? '', 
    );
  }
}
