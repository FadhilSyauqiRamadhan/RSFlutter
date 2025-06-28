import 'package:flutter/material.dart';
import '../models/rumah_sakit.dart';
import '../services/rumah_sakit_services.dart';

class TambahRumahSakitPage extends StatefulWidget {
  @override
  State<TambahRumahSakitPage> createState() => _TambahRumahSakitPageState();
}

class _TambahRumahSakitPageState extends State<TambahRumahSakitPage> {
  final _formKey = GlobalKey<FormState>();
  String nama = '';
  String alamat = '';
  String noTelpon = '';
  String type = '';
  double latitude = 0;
  double longitude = 0;

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      RumahSakit rs = RumahSakit(
        nama: nama,
        alamat: alamat,
        noTelpon: noTelpon,
        type: type,
        latitude: latitude,
        longitude: longitude,
      );
      await RumahSakitService.create(rs);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F0FA),
      appBar: AppBar(
        title: Text('Tambah Rumah Sakit'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue[900]),
        titleTextStyle: TextStyle(
          color: Colors.blue[900],
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.blue[900],
                        child: Icon(Icons.local_hospital, color: Colors.white, size: 38),
                      ),
                      SizedBox(height: 18),
                      Text(
                        "Formulir Data Rumah Sakit",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      _buildTextField(
                        label: 'Nama Rumah Sakit',
                        onSaved: (v) => nama = v!,
                      ),
                      _buildTextField(
                        label: 'Alamat Lengkap',
                        onSaved: (v) => alamat = v!,
                      ),
                      _buildTextField(
                        label: 'No Telpon',
                        onSaved: (v) => noTelpon = v!,
                        keyboardType: TextInputType.phone,
                      ),
                      _buildTextField(
                        label: 'Tipe Rumah Sakit',
                        onSaved: (v) => type = v!,
                      ),
                      _buildTextField(
                        label: 'Latitude',
                        onSaved: (v) => latitude = double.parse(v!),
                        keyboardType: TextInputType.number,
                      ),
                      _buildTextField(
                        label: 'Longitude',
                        onSaved: (v) => longitude = double.parse(v!),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: submit,
                          icon: Icon(Icons.save),
                          label: Text('Simpan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
        onSaved: onSaved,
        keyboardType: keyboardType,
      ),
    );
  }
}