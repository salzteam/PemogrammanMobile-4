import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, String> _profile = {
    'Nama Pengguna': 'Akshal Rizki Gandari',
    'Email': 'akshalrizkigandari@student.esaunggul.ac.id',
    'NIM': '20230801448',
    'Program Studi': 'Teknik Informatika',
    'Status Akademik': 'Mahasiswa aktif',
    'Alamat': 'Jakarta Barat',
  };

  Future<void> _editProfile() async {
    final controllers = <String, TextEditingController>{};

    for (final key in _profile.keys) {
      controllers[key] = TextEditingController(
        text: _profile[key],
      );
    }

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profil Pengguna'),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _profile.keys.map((key) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: controllers[key],
                      decoration: InputDecoration(
                        labelText: key,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: key == 'Email'
                          ? TextInputType.emailAddress
                          : TextInputType.text,
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
        _profile.addAll(result);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui.'),
        ),
      );
    }
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF2563EB),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        subtitle: Text(
          value.isEmpty ? '-' : value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 26,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundColor: Color(0xFFEDE9FE),
                child: Icon(
                  Icons.person,
                  size: 54,
                  color: Color(0xFF7C3AED),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                _profile['Nama Pengguna'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _profile['Email'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 14),
              const Chip(
                avatar: Icon(
                  Icons.school_outlined,
                  size: 18,
                ),
                label: Text('Mahasiswa'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _editProfile,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit Profil'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Informasi Pengguna',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildProfileItem(
          icon: Icons.badge_outlined,
          title: 'Nomor Induk Mahasiswa',
          value: _profile['NIM'] ?? '',
        ),
        _buildProfileItem(
          icon: Icons.school_outlined,
          title: 'Program Studi',
          value: _profile['Program Studi'] ?? '',
        ),
        _buildProfileItem(
          icon: Icons.calendar_month_outlined,
          title: 'Status Akademik',
          value: _profile['Status Akademik'] ?? '',
        ),
        _buildProfileItem(
          icon: Icons.location_on_outlined,
          title: 'Alamat',
          value: _profile['Alamat'] ?? '',
        ),
      ],
    );
  }
}
