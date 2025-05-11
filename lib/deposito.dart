import 'package:flutter/material.dart';

class DepositoPage extends StatefulWidget {
  final double currentSaldo;
  final void Function(double) updateSaldo;

  const DepositoPage({
    Key? key,
    required this.currentSaldo,
    required this.updateSaldo,
  }) : super(key: key);

  @override
  _DepositoPageState createState() => _DepositoPageState();
}

class _DepositoPageState extends State<DepositoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jumlahController = TextEditingController();
  String _jangkaWaktu = '1 bulan';

  static const Color mainBlue = Color(0xFF0A237E);

  void _deposit() {
    if (_formKey.currentState?.validate() ?? false) {
      double depositoAmount = double.tryParse(_jumlahController.text) ?? 0;

      if (widget.currentSaldo >= depositoAmount) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Konfirmasi Deposito'),
                content: Text(
                  'Anda ingin mendepositkan Rp${_jumlahController.text} '
                  'dengan jangka waktu $_jangkaWaktu? Saldo Anda akan berkurang.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      double saldoBaru = widget.currentSaldo - depositoAmount;
                      widget.updateSaldo(saldoBaru);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Deposito berhasil!')),
                      );

                      _jumlahController.clear();
                      setState(() {
                        _jangkaWaktu = '1 bulan';
                      });
                    },
                    child: const Text('Ya'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Batal'),
                  ),
                ],
              ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saldo Anda tidak cukup untuk deposito!'),
          ),
        );
      }
    }
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: mainBlue),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: mainBlue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Deposito', style: TextStyle(color: Colors.white)),
        backgroundColor: mainBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Formulir Deposito',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainBlue,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Input jumlah
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(
                  'Jumlah Deposito',
                  'Contoh: 5000000',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Jumlah harus lebih dari 0';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Dropdown jangka waktu
              DropdownButtonFormField<String>(
                value: _jangkaWaktu,
                decoration: _inputDecoration('Jangka Waktu', ''),
                onChanged: (newValue) {
                  setState(() {
                    _jangkaWaktu = newValue!;
                  });
                },
                items:
                    ['1 bulan', '3 bulan', '6 bulan', '1 tahun']
                        .map(
                          (jangka) => DropdownMenuItem(
                            value: jangka,
                            child: Text(jangka),
                          ),
                        )
                        .toList(),
              ),

              const SizedBox(height: 30),

              // Tombol kirim
              Center(
                child: SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: _deposit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Lakukan Deposito',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
