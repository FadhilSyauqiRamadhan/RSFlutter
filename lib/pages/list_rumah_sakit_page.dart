import 'package:flutter/material.dart';
import '../models/rumah_sakit.dart';
import '../services/rumah_sakit_services.dart';
import 'tambah_rumah_sakit_page.dart';
import 'detail_rumah_sakit_page.dart';

class ListRumahSakitPage extends StatefulWidget {
  @override
  State<ListRumahSakitPage> createState() => _ListRumahSakitPageState();
}

class _ListRumahSakitPageState extends State<ListRumahSakitPage> {
  List<RumahSakit> _rumahSakitList = [];
  List<RumahSakit> _filteredRumahSakitList = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getRumahSakit();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String keyword = _searchController.text.toLowerCase();
    setState(() {
      _filteredRumahSakitList = _rumahSakitList
          .where((rs) => rs.nama.toLowerCase().contains(keyword))
          .toList();
    });
  }

  Future<void> _getRumahSakit() async {
    setState(() => _isLoading = true);
    final rumahSakitList = await RumahSakitService.fetchAll();
    setState(() {
      _rumahSakitList = rumahSakitList;
      _filteredRumahSakitList = rumahSakitList;
      _isLoading = false;
    });
  }

  Future<void> _hapusRumahSakit(int id) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Konfirmasi"),
        content: Text("Yakin ingin menghapus rumah sakit ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Hapus")),
        ],
      ),
    );
    if (konfirmasi == true) {
      await RumahSakitService.delete(id);
      _getRumahSakit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FAFC),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            "Rumah Sakit\nIndonesia",
            style: TextStyle(
              color: Colors.blue[900],
              fontWeight: FontWeight.bold,
              fontSize: 28,
              letterSpacing: 1.2,
              height: 1.1,
            ),
          ),
        ),
        toolbarHeight: 90,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 110),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Cari rumah sakit...",
                      prefixIcon: Icon(Icons.search, color: Colors.blue[900]),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _filteredRumahSakitList.isEmpty
                          ? Center(child: Text("Data tidak ditemukan"))
                          : ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              itemCount: _filteredRumahSakitList.length,
                              separatorBuilder: (_, __) => SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final rs = _filteredRumahSakitList[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(16),
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[900],
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Icon(Icons.local_hospital, color: Colors.white, size: 32),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                rs.nama,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.blue[900],
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on, color: Colors.blue[300], size: 16),
                                                  SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      rs.alamat,
                                                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(Icons.phone, color: Colors.blue[300], size: 16),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    rs.noTelpon,
                                                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  OutlinedButton.icon(
                                                    style: OutlinedButton.styleFrom(
                                                      foregroundColor: Colors.blue[900],
                                                      side: BorderSide(color: Colors.blue[900]!),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                    icon: Icon(Icons.info_outline),
                                                    label: Text("Detail"),
                                                    onPressed: () async {
                                                      await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => DetailRumahSakitPage(id: rs.id!),
                                                        ),
                                                      );
                                                      _getRumahSakit();
                                                    },
                                                  ),
                                                  SizedBox(width: 8),
                                                  OutlinedButton.icon(
                                                    style: OutlinedButton.styleFrom(
                                                      foregroundColor: Colors.red[700],
                                                      side: BorderSide(color: Colors.red[700]!),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                    icon: Icon(Icons.delete_outline),
                                                    label: Text("Hapus"),
                                                    onPressed: () => _hapusRumahSakit(rs.id!),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
                SizedBox(height: 70),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                icon: Icon(Icons.add, size: 24),
                label: Text(
                  "Tambah Rumah Sakit",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 6,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TambahRumahSakitPage()),
                  ).then((_) => _getRumahSakit());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}