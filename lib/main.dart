import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
    home: const ExpenseApp()));

class ExpenseApp extends StatefulWidget {
  const ExpenseApp({super.key});

  @override
  State<ExpenseApp> createState() => _ExpenseAppState();
}

class _ExpenseAppState extends State<ExpenseApp> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isLoading = false;

  // ตั้งค่าประเภทหลัก: รายรับ หรือ รายจ่าย
  String _transactionType = 'รายจ่าย';

  // รายการปุ่มหมวดหมู่
  final List<String> _categories = [
    'อาหาร',
    'เดินทาง',
    'ของใช้',
    'บันเทิง',
    'เงินเดือน',
    'อื่นๆ'
  ];
  String _selectedCategory = 'อาหาร';

  // URL Google Script ของคุณ
  final String scriptUrl =
      'https://script.google.com/macros/s/AKfycbwfIzmLF_KFI2AOzVF06LUqgJ6kFHwgM8tdk5ivyiHrS61V3c1HGXZ10T4Tp0sIarCv/exec';

  Future<void> sendData() async {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบ")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await http.post(
        Uri.parse(scriptUrl),
        body: jsonEncode({
          "title": _titleController.text,
          "amount": _amountController.text,
          "type":
              "$_transactionType: $_selectedCategory" // ส่งไปเช่น "รายจ่าย: อาหาร"
        }),
      );

      _titleController.clear();
      _amountController.clear();

      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text("บันทึกสำเร็จ"),
          content: const Text("ข้อมูลถูกส่งไปยัง Google Sheet แล้ว"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(c), child: const Text("ตกลง"))
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('บันทึกค่าใช้จ่าย'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'รายการ'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'จำนวนเงิน'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<String>(
                  value: 'รายจ่าย',
                  groupValue: _transactionType,
                  onChanged: (value) {
                    setState(() {
                      _transactionType = value!;
                    });
                  },
                ),
                const Text('รายจ่าย'),
                Radio<String>(
                  value: 'รายรับ',
                  groupValue: _transactionType,
                  onChanged: (value) {
                    setState(() {
                      _transactionType = value!;
                    });
                  },
                ),
                const Text('รายรับ'),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: _categories
                  .map((category) => ChoiceChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedCategory = category;
                            }
                          });
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: sendData,
                    child: const Text('บันทึก'),
                  ),
          ],
        ),
      ),
    );
  }
}
