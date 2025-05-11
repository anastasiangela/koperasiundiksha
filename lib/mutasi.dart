import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MutasiPage extends StatelessWidget {
  // Menerima parameter mutasiList sebagai parameter konstruktor
  final List<Map<String, dynamic>> mutasiList;

  MutasiPage({
    required this.mutasiList,
  }); // Konstruktor yang menerima mutasiList

  final Color mainBlue = Color(0xFF0A237E);

  String formatRupiah(double amount) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'id', 
      symbol: 'Rp ', 
      decimalDigits: 0, 
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Latar belakang putih
      appBar: AppBar(
        backgroundColor: mainBlue,
        title: Text(
          'Riwayat Mutasi',
          style: TextStyle(color: Colors.white), // ✅ Teks putih
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: mutasiList.isEmpty
          ? Center(child: Text('Belum ada transaksi', style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.builder(
              itemCount: mutasiList.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final mutasi = mutasiList[index];
                final isPositive = mutasi['jumlah'] >= 0;

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(
                      isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      mutasi['jenis'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mutasi['keterangan'],
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        SizedBox(height: 4),
                        Text(
                          DateFormat('dd MMM yyyy – HH:mm').format(mutasi['tanggal']),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Text(
                      formatRupiah(mutasi['jumlah']),
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
