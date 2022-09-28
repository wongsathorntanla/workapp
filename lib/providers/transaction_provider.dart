import 'package:flutter/foundation.dart';
import 'package:flutter_database/database/transaction_db.dart';
import 'package:flutter_database/models/Transactions.dart';


class TransactionProvider with ChangeNotifier {
    
    List<Transactions> transactions = [
    
    ];

    //ดึงข้อมูล
    List<Transactions> getTransaction(){
      return transactions;
    }

   void addTransaction(Transactions statement) async{
      var db = TransactionDB ( dbName : " transactions.db " ) ;
      //บันทึกข้อมูล
      await db.InsertData ( statement ) ;

      // ดึงข้อมูลมาแสดงผล
      transactions=await db.LoadAllData ( ) ;
      transactions.insert(0,statement);
      //แจ้งเตือน consumer
      notifyListeners();
    }
}