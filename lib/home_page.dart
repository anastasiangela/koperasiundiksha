import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Color mainBlue = Color(0xFF0A237E); // Warna biru utama

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Koperasi Undiksha',
          style: TextStyle(color: Colors.white), // Perbaikan
        ),
        centerTitle: true, // Memastikan judul ada di tengah
        backgroundColor: mainBlue,
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ), // Ikon keluar jadi putih
            onPressed: () {
              // Fungsi keluar
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
                          onPressed:
                              () => Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst),
                          child: Text('Keluar'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),

      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Bagian Profil dan Saldo
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage('assets/angel.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          _infoCard('Nasabah', 'Anastasia Angela'),
                          SizedBox(height: 10),
                          _infoCard('Total Saldo Anda', 'Rp. 1.200.000'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Grid Menu Utama
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
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
                    _menuCard(Icons.account_balance_wallet, 'Cek Saldo'),
                    _menuCard(Icons.send, 'Transfer'),
                    _menuCard(Icons.savings, 'Deposito'),
                    _menuCard(Icons.payment, 'Pembayaran'),
                    _menuCard(Icons.money, 'Pinjaman'),
                    _menuCard(Icons.receipt, 'Mutasi'),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Bantuan
              Column(
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
                        '0878-1234-1024',
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
              ),
              SizedBox(height: 20),

              // Bottom Menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _bottomMenu(Icons.settings, 'Setting', false),
                  _bottomMenu(Icons.qr_code, 'QR Code', true),
                  _bottomMenu(Icons.person, 'Profile', false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Informasi Kartu seperti 'Nasabah' dan 'Saldo'
  Widget _infoCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFD7DDFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
    );
  }

  // Menu utama di tengah (Cek Saldo, Transfer, dsb)
  Widget _menuCard(IconData icon, String title) {
    return Container(
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
              color: Color(0xFF0A237E),
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
    );
  }

  // Menu bawah (Setting, QR, Profile)
  Widget _bottomMenu(IconData icon, String title, bool isMain) {
    final double size = isMain ? 70 : 50;

    return Column(
      children: [
        Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isMain ? Color(0xFF0A237E) : Colors.white,
            borderRadius: BorderRadius.circular(isMain ? 35 : 10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
            border:
                isMain ? null : Border.all(color: Color(0xFF0A237E), width: 2),
          ),
          child: Icon(
            icon,
            size: isMain ? 40 : 25,
            color: isMain ? Colors.white : Color(0xFF0A237E),
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
