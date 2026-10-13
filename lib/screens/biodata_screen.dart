import 'package:flutter/material.dart';

class BiodataScreen extends StatefulWidget {
  const BiodataScreen({super.key});

  @override
  State<BiodataScreen> createState() => _BiodataScreenState();
}

class _BiodataScreenState extends State<BiodataScreen> {
  final Map<String, String> _biodata = {
    'Nama Lengkap': 'Akshal Rizki Gandari',
    'NIM': '20230801448',
    'Tempat, Tanggal Lahir': 'Jakarta, 16 Juli 2003',
    'Jenis Kelamin': 'Laki-laki',
    'Alamat': 'Jakarta Barat',
    'Email': 'akshalrizkigandari@student.esaunggul.ac.id',
    'Nomor Telepon': '0812345678',
    'Perguruan Tinggi': 'Universitas Esa Unggul',
    'Program Studi': 'Teknik Informatika',
    'Fakultas': 'Ilmu Komputer',
    'Semester': '7',
    'Status Pekerjaan': 'Mahasiswa / Bekerja',
    'Instansi': 'Nama Perusahaan atau Instansi',
    'Posisi': 'Fullstack Developer',
    'Nama Organisasi': 'Nama organisasi',
    'Jabatan Organisasi': 'Anggota / Pengurus',
    'Periode Organisasi': 'Tahun mulai - tahun selesai',
  };

  final Map<String, List<String>> _groups = {
    'Biodata Pribadi': [
      'Nama Lengkap',
      'NIM',
      'Tempat, Tanggal Lahir',
      'Jenis Kelamin',
      'Alamat',
      'Email',
      'Nomor Telepon',
    ],
    'Pendidikan': [
      'Perguruan Tinggi',
      'Program Studi',
      'Fakultas',
      'Semester',
    ],
    'Pekerjaan': [
      'Status Pekerjaan',
      'Instansi',
      'Posisi',
    ],
    'Organisasi': [
      'Nama Organisasi',
      'Jabatan Organisasi',
      'Periode Organisasi',
    ],
  };

  Future<void> _editBiodata() async {
    final controllers = <String, TextEditingController>{};

    for (final key in _biodata.keys) {
      controllers[key] = TextEditingController(
        text: _biodata[key],
      );
    }

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Biodata Mahasiswa'),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _biodata.keys.map((key) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: controllers[key],
                      decoration: InputDecoration(
                        labelText: key,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedData = <String, String>{};

                for (final key in controllers.keys) {
                  updatedData[key] = controllers[key]!.text.trim();
                }

                Navigator.pop(dialogContext, updatedData);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    for (final controller in controllers.values) {
      controller.dispose();
    }

    if (result != null) {
      setState(() {
        _biodata.addAll(result);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biodata berhasil diperbarui.'),
        ),
      );
    }
  }

  Widget _buildSection(String title, List<String> fields) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
            const Divider(height: 24),
            ...fields.map((field) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _biodata[field] ?? '-',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Center(
          child: CircleAvatar(
            radius: 44,
            backgroundColor: Color(0xFFDBEAFE),
            child: Icon(
              Icons.person,
              size: 52,
              color: Color(0xFF2563EB),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            _biodata['Nama Lengkap'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            'NIM: ${_biodata['NIM']}',
            style: const TextStyle(color: Colors.black54),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _editBiodata,
            icon: const Icon(Icons.edit),
            label: const Text('Edit Biodata'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ..._groups.entries.map(
          (entry) => _buildSection(entry.key, entry.value),
        ),
      ],
    );
  }
}
