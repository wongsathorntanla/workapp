import 'package:flutter/foundation.dart';
import 'package:flutter_database/database/transaction_db.dart';
import 'package:flutter_database/models/Transactions.dart';

class TransactionProvider with ChangeNotifier {
  List<Transactions> transactions = [];
  List<Transactions> filter = [];
  String filterdropdown = 'รายการวันนี้';
  //ดึงข้อมูล
  List<Transactions> getTransaction() {
    return transactions;
  }

  dropdownset(data) {
    filterdropdown = data;
    notifyListeners();
  }

  Future<void> filterAdd(filter) async {
    if (transactions.isNotEmpty) {
      if (filter == 'รายการวันนี้') {
        filter = transactions
            .where((element) =>
                element.date.day == DateTime.now().day &&
                element.date.month == DateTime.now().month &&
                element.date.year == DateTime.now().year)
            .toList();
      } else if (filter == 'รายการใน 7 วันที่ผ่านมา') {
        filter = transactions
            .where((element) => DateTime.now().day >= DateTime.now().day - 7)
            .toList();
      } else if (filter == 'รายการในเดือนนี้') {
        filter = transactions
            .where(
                (element) => DateTime.now().month >= DateTime.now().month - 1)
            .toList();
      }
    }
    notifyListeners();
  }

  void initData() async {
    var db = TransactionDB(dbName: "transactions.db");
    transactions = await db.loadAllData();
    notifyListeners();
  }

  void addTransaction(Transactions statement) async {
    var db = TransactionDB(dbName: "transactions.db");
    //บันทึกข้อมูล
    await db.InsertData(statement);

    // ดึงข้อมูลมาแสดงผล
    transactions = await db.loadAllData();
    print(transactions);
    // transactions.insert(0, statement);
    //แจ้งเตือน consumer
    notifyListeners();
  }
}
