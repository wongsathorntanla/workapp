import 'package:flutter/material.dart';
import 'package:flutter_database/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  List<String> list = <String>[
    'รายการวันนี้',
    'รายการใน 7 วันที่ผ่านมา',
    'รายการในเดือนนี้',
    'รายการทั้งหมด'
  ];

  @override
  Widget build(BuildContext context) {
    String dropdownValue = list.first;

    return DropdownButton<String>(
      value: context.watch<TransactionProvider>().filterdropdown,
      icon: const Icon(Icons.arrow_drop_down_rounded),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 1,
        color: Theme.of(context).primaryColor,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        dropdownValue = value!;
        context.read<TransactionProvider>().dropdownset(dropdownValue);
        context.read<TransactionProvider>().filterAdd(dropdownValue);
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
