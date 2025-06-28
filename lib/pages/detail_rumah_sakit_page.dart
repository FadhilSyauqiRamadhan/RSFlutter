import 'package:flutter/material.dart';
import '../models/rumah_sakit.dart';
import '../services/rumah_sakit_services.dart';
import 'maps.dart';
import 'update_rumah_sakit_page.dart';

class DetailRumahSakitPage extends StatefulWidget {
  final int id;
  const DetailRumahSakitPage({required this.id, Key? key}) : super(key: key);

  @override
  State<DetailRumahSakitPage> createState() => _DetailRumahSakitPageState();
}

class _DetailRumahSakitPageState extends State<DetailRumahSakitPage> {
  late Future<RumahSakit> rumahSakitFuture;

  @override
  void initState() {
    super.initState();
    rumahSakitFuture = RumahSakitService.fetchById(widget.id);
  }

  void refreshDetail() {
    setState(() {
      rumahSakitFuture = RumahSakitService.fetchById(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue[900]),
        title: Text(
          'Detail Rumah Sakit',
          style: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<RumahSakit>(
        future: rumahSakitFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Gagal memuat detail'));
          if (!snapshot.hasData)
            return Center(child: Text('Data tidak ditemukan'));

          final rs = snapshot.data!;

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Badge status
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("Online", style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.w600)),
                        ),
                      ),
                      SizedBox(height: 8),
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.blue[900],
                        child: Icon(Icons.local_hospital, color: Colors.white, size: 44),
                      ),
                      SizedBox(height: 16),
                      Text(
                        rs.nama,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          rs.type,
                          style: TextStyle(color: Colors.blue[900], fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: 18),
                      Divider(),
                      SizedBox(height: 10),
                      _infoRow(Icons.location_on, "Alamat", rs.alamat),
                      SizedBox(height: 10),
                      _infoRow(Icons.phone, "Telepon", rs.noTelpon),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Lokasi Rumah Sakit",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: RumahSakitMaps(latitude: rs.latitude, longitude: rs.longitude),
              ),
              SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UpdateRumahSakitPage(rumahSakit: rs),
                      ),
                    );
                    if (result == true) {
                      refreshDetail();
                    }
                  },
                  icon: Icon(Icons.edit),
                  label: Text("Edit Informasi", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue[300], size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}