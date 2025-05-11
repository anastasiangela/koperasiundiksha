import 'package:flutter/material.dart';

class PinjamanPage extends StatefulWidget {
  final ValueNotifier<double> saldo;

  const PinjamanPage({Key? key, required this.saldo}) : super(key: key);

  @override
  _PinjamanPageState createState() => _PinjamanPageState();
}

class _PinjamanPageState extends State<PinjamanPage> {
  final TextEditingController _jumlahPinjamanController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _ajukanPinjaman() {
    if (_formKey.currentState!.validate()) {
      double jumlahPinjaman = double.parse(_jumlahPinjamanController.text);

      widget.saldo.value += jumlahPinjaman;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Pinjaman Disetujui',
              style: TextStyle(color: Color(0xFF1A49A0)),
            ),
            content: Text(
              'Pinjaman sebesar Rp ${jumlahPinjaman.toStringAsFixed(2).replaceAll('.', ',')} telah ditambahkan ke saldo Anda.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('OK', style: TextStyle(color: Color(0xFF1A49A0))),
              ),
            ],
          );
        },
      );

      _jumlahPinjamanController.clear();
    }
  }

  @override
  void dispose() {
    _jumlahPinjamanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1A49A0); // Biru soft

    return Scaffold(
      appBar: AppBar(
        title: Text('Ajukan Pinjaman', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white, // Latar belakang putih
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Masukkan jumlah pinjaman yang Anda butuhkan:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _jumlahPinjamanController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah Pinjaman',
                  labelStyle: TextStyle(color: primaryColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah pinjaman tidak boleh kosong';
                  }
                  final jumlah = double.tryParse(value);
                  if (jumlah == null || jumlah <= 0) {
                    return 'Masukkan jumlah yang valid';
                  }
                  if (jumlah < 500000) {
                    return 'Minimal pinjaman adalah Rp 500.000';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _ajukanPinjaman,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: 4,
                    shadowColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Ajukan Pinjaman',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
