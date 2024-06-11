class Publicacion {
  final String Usuario;
  final String Descripcion;
  final String Imagen;
  final String? Video;
  final String? Audio;

  Publicacion({
    required this.Usuario,
    required this.Descripcion,
    required this.Imagen,
    this.Video,
    this.Audio,
  });

  factory Publicacion.fromMap(Map<String, dynamic> data) {
    return Publicacion(
      Usuario: data['Usuario'] ?? '',
      Descripcion: data['Descripcion'] ?? '',
      Imagen: data['Imagen'] ?? '',
      Video: data['Video'] ?? '',
      Audio: data['Audio'] ?? '',
    );
  }
}
