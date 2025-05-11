import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double saldo = 1200000.00;

  void _updateSaldo(double transferAmount) {
    setState(() {
      saldo -= transferAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Koperasi')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saldo Anda:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Rp ${saldo.toStringAsFixed(2).replaceAll('.', ',')}',
              style: TextStyle(fontSize: 28, color: Colors.green.shade700),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => TransferPage(
                          currentSaldo: saldo,
                          onTransferSuccess: _updateSaldo,
                        ),
                  ),
                );
              },
              child: const Text('Transfer'),
            ),
          ],
        ),
      ),
    );
  }
}

class TransferPage extends StatefulWidget {
  final double currentSaldo;
  final Function(double) onTransferSuccess;

  const TransferPage({
    required this.currentSaldo,
    required this.onTransferSuccess,
    Key? key,
  }) : super(key: key);

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _formKey = GlobalKey<FormState>();
  final _rekeningController = TextEditingController();
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();
  String? _selectedBank;
  bool _isProcessing = false;

  final List<String> _bankList = [
    'BCA',
    'BNI',
    'BRI',
    'Mandiri',
    'CIMB Niaga',
    'Danamon',
    'BTN',
    'Permata',
  ];

  Future<bool?> _showAnimatedDialog(Widget dialog) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (_, __, ___) => dialog,
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _handleTransfer() async {
    if (_formKey.currentState!.validate()) {
      final double jumlah = double.parse(
        _jumlahController.text.replaceAll(',', '.'),
      );

      if (jumlah > widget.currentSaldo) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Saldo tidak cukup!')));
        return;
      }

      final confirm = await _showAnimatedDialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Center(
            child: Text(
              'Konfirmasi Transfer',
              style: TextStyle(
                color: Color(0xFF1A237E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Transfer dari saldo Anda ke:'),
              const SizedBox(height: 10),
              Text('Bank: $_selectedBank'),
              Text('No. Rekening: ${_rekeningController.text}'),
              Text('Nama: ${_namaController.text}'),
              Text(
                'Jumlah: Rp ${jumlah.toStringAsFixed(2).replaceAll('.', ',')}',
              ),
              const SizedBox(height: 10),
              const Text(
                'Pastikan nomor dan nama penerima sudah benar.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            _dialogButton(
              label: 'Batal',
              isPrimary: false,
              onPressed: () => Navigator.pop(context, false),
            ),
            _dialogButton(
              label: 'OK',
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      final pinSuccess = await _showAnimatedDialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Center(
            child: Text(
              'Autentikasi',
              style: TextStyle(
                color: Color(0xFF1A237E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Masukkan PIN Anda'),
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  hintText: '••••••',
                  counterText: '',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            _dialogButton(
              label: 'Batal',
              isPrimary: false,
              onPressed: () => Navigator.pop(context, false),
            ),
            _dialogButton(
              label: 'Lanjut',
              onPressed: () {
                // Ganti validasi PIN sesuai kebutuhan
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      );

      if (pinSuccess != true) return;

      setState(() => _isProcessing = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isProcessing = false);
      widget.onTransferSuccess(jumlah);

      await _showAnimatedDialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Center(
            child: Text(
              'Transfer Berhasil',
              style: TextStyle(
                color: Color(0xFF1A237E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Text(
            'Transfer sebesar Rp ${jumlah.toStringAsFixed(2).replaceAll('.', ',')} berhasil dilakukan.',
          ),
          actions: [
            _dialogButton(
              label: 'OK',
              onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            ),
          ],
        ),
      );
    }
  }

  Widget _dialogButton({
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = true,
  }) {
    final color = isPrimary ? const Color(0xFF1A237E) : Colors.grey;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    TextInputType inputType, {
    bool isAmount = false,
    bool isRekening = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF0A237E)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF0A237E)),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF0A237E), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Tidak boleh kosong';
        if (isRekening && !RegExp(r'^\d{10,16}$').hasMatch(value)) {
          return 'Nomor rekening tidak valid';
        }
        if (isAmount) {
          final amount = double.tryParse(value.replaceAll(',', '.'));
          if (amount == null || amount < 10000) {
            return 'Minimal transfer Rp 10.000';
          }
          if (amount > widget.currentSaldo) return 'Saldo tidak cukup';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownBank() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Pilih Bank Tujuan',
        labelStyle: const TextStyle(color: Color(0xFF0A237E)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0A237E)),
        ),
      ),
      value: _selectedBank,
      items:
          _bankList
              .map((bank) => DropdownMenuItem(value: bank, child: Text(bank)))
              .toList(),
      onChanged: (value) => setState(() => _selectedBank = value),
      validator: (value) => value == null ? 'Silakan pilih bank' : null,
    );
  }

  @override
  void dispose() {
    _rekeningController.dispose();
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color mainBlue = const Color(0xFF0A237E);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Transfer', style: TextStyle(color: Colors.white)),
        backgroundColor: mainBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Text(
                  'Formulir Transfer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainBlue,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildDropdownBank(),
              const SizedBox(height: 15),
              _buildTextField(
                _rekeningController,
                'No. Rekening Tujuan',
                TextInputType.number,
                isRekening: true,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _namaController,
                'Nama Penerima',
                TextInputType.text,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                _jumlahController,
                'Jumlah Transfer',
                TextInputType.number,
                isAmount: true,
              ),
              const SizedBox(height: 25),
              Center(
                child: SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _handleTransfer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child:
                        _isProcessing
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Kirim',
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
