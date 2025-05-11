import 'package:flutter/material.dart';

class CekSaldoPage extends StatefulWidget {
  final ValueNotifier<double> saldo;

  const CekSaldoPage({super.key, required this.saldo});

  @override
  State<CekSaldoPage> createState() => _CekSaldoPageState();
}

class _CekSaldoPageState extends State<CekSaldoPage> {
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    // Tampilkan popup setelah 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      _showSaldoDialog();
    });
  }

  void _showSaldoDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Saldo Anda',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E), // Warna biru tua
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Menampilkan waktu terkini
                  Text(
                    'Saldo diperiksa pada:\n${_getCurrentTime()}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  // Menampilkan saldo terbaru dari ValueNotifier
                  ValueListenableBuilder<double>(
                    valueListenable: widget.saldo,
                    builder: (context, saldo, _) {
                      return Text(
                        'Rp. ${_formatSaldo(saldo)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    'Nomor Rekening: 1180845859',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  // Tombol OK dengan efek animasi
                  GestureDetector(
                    onTapDown: (_) {
                      setStateDialog(() {
                        isPressed = true;
                      });
                    },
                    onTapUp: (_) {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        setStateDialog(() {
                          isPressed = false;
                        });
                        Navigator.of(context).pop(); // Tutup popup
                        Navigator.of(this.context).pop(); // Tutup halaman
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isPressed
                                ? const Color(0xFF3F51B5)
                                : const Color(0xFF1A237E),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow:
                            isPressed
                                ? []
                                : [
                                  const BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 4),
                                    blurRadius: 6,
                                  ),
                                ],
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  String _formatSaldo(double saldo) {
    return saldo.toStringAsFixed(2).replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      appBar: AppBar(
        title: const Text(
          'Info Saldo',
          style: TextStyle(color: Colors.white), // Warna putih
        ),
        backgroundColor: const Color(0xFF1A237E),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // Ikon juga putih
      ),
      body: const SizedBox.shrink(),
    );
  }
}
