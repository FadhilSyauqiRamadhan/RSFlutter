import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rumah_sakit.dart';

class RumahSakitService {
  static const String baseUrl = 'http://192.168.1.8:8000/api/rumah-sakit'; // Ganti dengan IP API kamu

  static Future<List<RumahSakit>> fetchAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => RumahSakit.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  static Future<RumahSakit> fetchById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return RumahSakit.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal memuat detail');
    }
  }

  static Future<void> create(RumahSakit rs) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(rs.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Gagal menambah data');
    }
  }

  static Future<void> update(int id, RumahSakit rs) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(rs.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal mengupdate data');
    }
  }

  static Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus data');
    }
  }
}