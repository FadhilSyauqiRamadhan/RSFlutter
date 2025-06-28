class RumahSakit {
  final int? id;
  final String nama;
  final String alamat;
  final String noTelpon;
  final String type;
  final double latitude;
  final double longitude;

  RumahSakit({
    this.id,
    required this.nama,
    required this.alamat,
    required this.noTelpon,
    required this.type,
    required this.latitude,
    required this.longitude,
  });

  factory RumahSakit.fromJson(Map<String, dynamic> json) {
    return RumahSakit(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      noTelpon: json['no_telpon'],
      type: json['type'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'alamat': alamat,
        'no_telpon': noTelpon,
        'type': type,
        'latitude': latitude,
        'longitude': longitude,
      };
}