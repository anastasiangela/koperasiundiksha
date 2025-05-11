// settings.dart (perbaikan tombol OK dialog)
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showGantiKataSandiDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _oldPasswordController =
        TextEditingController();
    final TextEditingController _newPasswordController =
        TextEditingController();
    const primaryColor = Color(0xFF1A49A0);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Ganti Kata Sandi',
            style: TextStyle(color: primaryColor),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Kata Sandi Lama',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan kata sandi lama';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Kata Sandi Baru',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukkan kata sandi baru';
                    }
                    if (value.length < 6) {
                      return 'Minimal 6 karakter';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: primaryColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop(); // Tutup dialog ganti sandi

                  // Dialog konfirmasi berhasil
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: Text(
                            'Berhasil',
                            style: TextStyle(color: primaryColor),
                          ),
                          content: Text('Kata sandi Anda telah diperbarui.'),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed:
                                  () =>
                                      Navigator.of(
                                        context,
                                      ).pop(), // Ini sekarang berfungsi
                              child: Text('OK'),
                            ),
                          ],
                        ),
                  );
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    const primaryColor = Color(0xFF1A49A0);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              'Konfirmasi Keluar',
              style: TextStyle(color: primaryColor),
            ),
            content: Text('Apakah Anda yakin ingin keluar dari akun Anda?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Batal', style: TextStyle(color: primaryColor)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog konfirmasi
                  Navigator.of(context).pop(); // Keluar ke halaman sebelumnya
                  // Tambahkan logika ke halaman login jika ada
                },
                child: Text('Keluar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1A49A0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          InkWell(
            onTap: () => _showGantiKataSandiDialog(context),
            splashColor: primaryColor.withOpacity(0.2),
            child: ListTile(
              leading: Icon(Icons.lock, color: primaryColor),
              title: Text('Ganti Kata Sandi'),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {
              // Aksi notifikasi (bisa ditambahkan navigasi ke halaman notifikasi)
            },
            splashColor: primaryColor.withOpacity(0.2),
            child: ListTile(
              leading: Icon(Icons.notifications, color: primaryColor),
              title: Text('Notifikasi'),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () => _showLogoutConfirmation(context),
            splashColor: primaryColor.withOpacity(0.2),
            child: ListTile(
              leading: Icon(Icons.logout, color: primaryColor),
              title: Text('Keluar'),
            ),
          ),
        ],
      ),
    );
  }
}
