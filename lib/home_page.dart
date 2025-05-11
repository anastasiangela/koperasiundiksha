import 'package:flutter/material.dart';
import 'login_page.dart';
import 'cek_saldo.dart';
import 'transfer.dart';
import 'deposito.dart';
import 'pembayaran.dart';
import 'pinjaman.dart';
import 'mutasi.dart';
import 'settings.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color mainBlue = Color(0xFF0A237E);
  final ValueNotifier<bool> _obscureText = ValueNotifier<bool>(true);
  final ValueNotifier<double> _saldo = ValueNotifier<double>(
    1200000.00,
  ); // Saldo awal
  final List<Map<String, dynamic>> _mutasiList = []; // Menyimpan riwayat mutasi

  @override
  void dispose() {
    _obscureText.dispose();
    _saldo.dispose();
    super.dispose();
  }

  void _addMutasi(String jenis, double jumlah, String keterangan) {
    setState(() {
      _mutasiList.insert(0, {
        'tanggal': DateTime.now(),
        'jenis': jenis,
        'jumlah': jumlah,
        'keterangan': keterangan,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Koperasi Undiksha', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: mainBlue,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text(
                        'Konfirmasi',
                        style: TextStyle(color: Colors.black),
                      ),
                      content: Text('Apakah Anda yakin ingin keluar?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text('Keluar'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileCard(),
            SizedBox(height: 20),
            _buildMenuGrid(),
            SizedBox(height: 20),
            _buildHelpSection(),
            SizedBox(height: 20),
            _buildBottomMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/angel.jpg'),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anastasia Angela',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Nasabah',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Saldo Anda:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscureText,
                      builder: (context, isObscured, _) {
                        return ValueListenableBuilder<double>(
                          valueListenable: _saldo,
                          builder: (context, saldo, _) {
                            return Row(
                              children: [
                                Text(
                                  isObscured
                                      ? 'Rp. ******'
                                      : 'Rp. ${saldo.toStringAsFixed(2).replaceAll('.', ',')}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isObscured
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    _obscureText.value = !isObscured;
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.1,
        children: [
          _menuCard(Icons.account_balance_wallet, 'Cek Saldo', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CekSaldoPage(saldo: _saldo),
              ),
            );
          }),
          _menuCard(Icons.send, 'Transfer', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => TransferPage(
                      currentSaldo: _saldo.value,
                      onTransferSuccess: (double amount) {
                        _saldo.value -= amount;
                        _addMutasi('Transfer', -amount, 'Transfer ke Budi');
                      },
                    ),
              ),
            );
          }),
          _menuCard(Icons.savings, 'Deposito', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => DepositoPage(
                      currentSaldo: _saldo.value,
                      updateSaldo: (newSaldo) {
                        setState(() {
                          _saldo.value = newSaldo;
                          _addMutasi(
                            'Deposito',
                            -newSaldo,
                            'Deposito bulan Mei',
                          );
                        });
                      },
                    ),
              ),
            );
          }),
          _menuCard(Icons.payment, 'Pembayaran', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => PembayaranPage(
                      currentSaldo: _saldo.value,
                      onPaymentSuccess: (double amount) {
                        _saldo.value -= amount;
                        _addMutasi(
                          'Pembayaran',
                          -amount,
                          'Pembayaran transaksi',
                        );
                      },
                    ),
              ),
            );
          }),
          _menuCard(Icons.money, 'Pinjaman', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PinjamanPage(saldo: _saldo),
              ),
            );
          }),
          _menuCard(Icons.receipt, 'Mutasi', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MutasiPage(mutasiList: _mutasiList),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _menuCard(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: mainBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection() {
    return Column(
      children: [
        Text(
          'Butuh Bantuan?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '0831-7022-1384',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.phone, color: mainBlue, size: 30),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
          child: _bottomMenu(Icons.settings, 'Setting', false),
        ),
        _bottomMenu(Icons.qr_code, 'QR Code', true),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          child: _bottomMenu(Icons.person, 'Profile', false),
        ),
      ],
    );
  }

  Widget _bottomMenu(IconData icon, String title, bool isMain) {
    final double size = isMain ? 70 : 50;
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isMain ? mainBlue : Colors.white,
            borderRadius: BorderRadius.circular(isMain ? 35 : 10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
            border: isMain ? null : Border.all(color: mainBlue, width: 2),
          ),
          child: Icon(
            icon,
            size: isMain ? 40 : 25,
            color: isMain ? Colors.white : mainBlue,
          ),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
