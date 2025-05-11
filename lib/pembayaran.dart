import 'package:flutter/material.dart';

class PembayaranPage extends StatefulWidget {
  final double? currentSaldo;
  final Function(double)? onPaymentSuccess;

  PembayaranPage({this.currentSaldo, this.onPaymentSuccess});

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _layananController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _kodePembayaranController =
      TextEditingController();

  final Color mainBlue = Color(0xFF0A237E);

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      // Mengubah jumlah dari input menjadi double
      double jumlah =
          double.tryParse(
            _jumlahController.text.replaceAll(',', '').replaceAll('.', ''),
          ) ??
          0;

      // Validasi saldo cukup
      if (widget.currentSaldo != null && jumlah > widget.currentSaldo!) {
        _showDialog(
          'Saldo Tidak Cukup',
          'Saldo Anda tidak mencukupi untuk melakukan pembayaran ini.',
        );
        return;
      }

      // Jika saldo cukup, panggil fungsi onPaymentSuccess untuk mengupdate saldo
      if (widget.onPaymentSuccess != null) {
        widget.onPaymentSuccess!(jumlah); // Update saldo setelah pembayaran
      }

      // Tampilkan pesan berhasil
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Pembayaran berhasil!')));

      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title, style: TextStyle(color: mainBlue)),
            content: Text(content),
            actions: [
              TextButton(
                child: Text('Tutup'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _layananController.dispose();
    _jumlahController.dispose();
    _kodePembayaranController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('Pembayaran', style: TextStyle(color: Colors.white)),
        backgroundColor: mainBlue,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Formulir Pembayaran',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: mainBlue,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _layananController,
                  decoration: InputDecoration(
                    labelText: 'Nama Layanan',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.payment, color: mainBlue),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama layanan wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _kodePembayaranController,
                  decoration: InputDecoration(
                    labelText: 'Kode Pembayaran',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.vpn_key, color: mainBlue),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kode pembayaran wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _jumlahController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Jumlah Pembayaran',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money, color: mainBlue),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah wajib diisi';
                    }
                    double? val = double.tryParse(
                      value.replaceAll(',', '').replaceAll('.', ''),
                    );
                    if (val == null || val <= 0) {
                      return 'Jumlah tidak valid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      shadowColor: Colors.black26,
                    ),
                    child: Text(
                      'Bayar Sekarang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
