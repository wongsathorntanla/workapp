// ignore_for_file: unnecessary_this, await_only_futures

import 'dart:io';

import 'package:flutter_database/models/Transactions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class TransactionDB {
  //บริการเกี่ยวกับฐานข้อมูล

  String dbName; //เก็บชื่อฐานข้อมูล

  //ถ้ายังไม่ถูกสร้าง => สร้าง
  //ถูกสร้างไว้แล้ว => เปิด
  TransactionDB({required this.dbName});

  Future<Database> openDatabase() async {
    //หาตำแหน่งที่จะเก็บข้อมูล
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDirectory.path, dbName);
    // สร้าง database
    DatabaseFactory dbFactory = await databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  //บันทึกข้อมูล
  Future<int> InsertData(Transactions statement) async {
    //ฐานข้อมูล => store
    // transaction.db = > expense
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");

    // json
    var keyID = store.add(db, {
      " title ": statement.title,
      " amount ": statement.amount,
      " date ": statement.date.toIso8601String()
    });
    db.close();
    return keyID;
  }

  // ตึงข้อมูล
  Future<List<Transactions>> loadAllData() async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");
    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder(Field.key, false)]));
    List<Transactions> transactionList =
        List<Transactions>.from(<Transactions>[]);
    //ดึงมาทีละแถว
    for (RecordSnapshot<int, Map<String, dynamic>> record in snapshot) {
      transactionList.add(Transactions(
          title: record.value[" title "],
          amount: record.value[" amount "],
          date: DateTime.parse(record.value[" date "])));
    }
    return transactionList;
  }
}
