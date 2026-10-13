import 'package:flutter/material.dart';

class NilaiScreen extends StatefulWidget {
  const NilaiScreen({super.key});

  @override
  State<NilaiScreen> createState() => _NilaiScreenState();
}

class _NilaiScreenState extends State<NilaiScreen> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _matkulController = TextEditingController();
  final _nilaiController = TextEditingController();

  final List<NilaiMahasiswa> _daftarNilai = [];

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _matkulController.dispose();
    _nilaiController.dispose();
    super.dispose();
  }

  String _hitungGrade(double nilai) {
    if (nilai >= 85) return 'A';
    if (nilai >= 75) return 'B';
    if (nilai >= 65) return 'C';
    if (nilai >= 50) return 'D';
    return 'E';
  }

  void _tambahNilai() {
    if (!_formKey.currentState!.validate()) return;

    final nama = _namaController.text.trim();
    final nim = _nimController.text.trim();
    final matkul = _matkulController.text.trim();
    final nilai = double.parse(_nilaiController.text.trim());

    setState(() {
      _daftarNilai.add(
        NilaiMahasiswa(
          nama: nama,
          nim: nim,
          mataKuliah: matkul,
          nilai: nilai,
          grade: _hitungGrade(nilai),
        ),
      );
    });

    _namaController.clear();
    _nimController.clear();
    _matkulController.clear();
    _nilaiController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data nilai berhasil ditambahkan.'),
      ),
    );
  }

  void _hapusNilai(int index) {
    setState(() {
      _daftarNilai.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data nilai berhasil dihapus.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Input Nilai Mahasiswa',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'Lengkapi formulir berikut untuk menambahkan data nilai.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 18),
        Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama mahasiswa',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama mahasiswa wajib diisi.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _nimController,
                    decoration: const InputDecoration(
                      labelText: 'NIM',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'NIM wajib diisi.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _matkulController,
                    decoration: const InputDecoration(
                      labelText: 'Mata kuliah',
                      prefixIcon: Icon(Icons.menu_book_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Mata kuliah wajib diisi.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _nilaiController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Nilai (0–100)',
                      prefixIcon: Icon(Icons.grade_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nilai wajib diisi.';
                      }

                      final parsed = double.tryParse(value.trim());

                      if (parsed == null) {
                        return 'Masukkan nilai berupa angka.';
                      }

                      if (parsed < 0 || parsed > 100) {
                        return 'Nilai harus antara 0 sampai 100.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _tambahNilai,
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Data Nilai'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Daftar Nilai Mahasiswa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Chip(label: Text('${_daftarNilai.length} data')),
          ],
        ),
        const SizedBox(height: 10),
        if (_daftarNilai.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: const [
                Icon(
                  Icons.inbox_outlined,
                  size: 42,
                  color: Colors.black38,
                ),
                SizedBox(height: 8),
                Text(
                  'Belum ada data nilai.',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          )
        else
          ...List.generate(
            _daftarNilai.length,
            (index) {
              final data = _daftarNilai[index];

              return Card(
                color: Colors.white,
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFDBEAFE),
                    child: Text(
                      data.grade,
                      style: const TextStyle(
                        color: Color(0xFF1D4ED8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    data.nama,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'NIM: ${data.nim}\n'
                      'Mata kuliah: ${data.mataKuliah}\n'
                      'Nilai: ${data.nilai}',
                    ),
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    tooltip: 'Hapus data',
                    onPressed: () => _hapusNilai(index),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class NilaiMahasiswa {
  final String nama;
  final String nim;
  final String mataKuliah;
  final double nilai;
  final String grade;

  const NilaiMahasiswa({
    required this.nama,
    required this.nim,
    required this.mataKuliah,
    required this.nilai,
    required this.grade,
  });
}
