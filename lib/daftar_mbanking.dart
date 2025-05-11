import 'package:flutter/material.dart';
import 'login_page.dart';

class DaftarMbankingPage extends StatefulWidget {
  @override
  _DaftarMbankingPageState createState() => _DaftarMbankingPageState();
}

class _DaftarMbankingPageState extends State<DaftarMbankingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Daftar Mbanking', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1A237E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Formulir Pendaftaran Mbanking',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(namaController, 'Nama Lengkap'),
                SizedBox(height: 15),
                _buildTextField(
                  emailController,
                  'Email',
                  keyboard: TextInputType.emailAddress,
                ),
                SizedBox(height: 15),
                _buildTextField(
                  noHpController,
                  'No. HP',
                  keyboard: TextInputType.phone,
                ),
                SizedBox(height: 15),
                _buildTextField(passwordController, 'Password', obscure: true),
                SizedBox(height: 25),
                Center(
                  child:
                      isLoading
                          ? CircularProgressIndicator(color: Color(0xFF1A237E))
                          : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1A237E),
                              padding: EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: _submitForm,
                            child: Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: obscure,
      decoration: _inputDecoration(label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        if (label == 'Email') {
          final emailPattern = RegExp(r'^[\w\.-]+@gmail\.com$');
          if (!emailPattern.hasMatch(value)) {
            return 'Email harus format yang valid dan berakhir dengan @gmail.com';
          }
        }
        if (label == 'No. HP' && !RegExp(r'^\d+$').hasMatch(value)) {
          return 'No. HP hanya boleh angka';
        }
        if (label == 'Password' && value.length < 8) {
          return 'Password minimal 8 karakter';
        }
        return null;
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF1A237E)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF1A237E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
      ),
      border: OutlineInputBorder(),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });

        namaController.clear();
        emailController.clear();
        noHpController.clear();
        passwordController.clear();

        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text('Sukses'),
                content: Text('Pendaftaran berhasil! Silakan login.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      });
    }
  }
}
