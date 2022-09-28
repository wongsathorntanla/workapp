import 'package:flutter/material.dart';
import 'package:flutter_database/models/Transactions.dart';
import 'package:flutter_database/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class Formscreen extends StatelessWidget {
  final formkey = GlobalKey<FormState>();

  // controller
  final titlecontroller = TextEditingController();//รับค่าชื่อรายการ
  final amountcontroller = TextEditingController();//รับตัวเลขจำนวนเงิน
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text("แบบฟอร์มบันทึกข้อมูล"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: new InputDecoration(labelText: "ชื่อรายการ"),
                  autofocus: true,
                  controller: titlecontroller,
                  validator: (String? str){
                    if(str!.isEmpty){
                      return "กรุณาป้อนชื่อรายการ";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: new InputDecoration(labelText: "จำนวนเงิน"),
                  keyboardType: TextInputType.number,
                  controller: amountcontroller,
                   validator: (String? str){
                    if(str!.isEmpty){
                      return "กรุณาป้อนจำนวนเงิน";
                    }
                    if(double.parse(str)<=0){
                        return "กรุณาป้อนตัวเลขมากกว่า 0";
                    }
                    return null;
                  },
                ),
                TextButton(
                  child: Text("เพิ่มข้อมูล"),
                  onPressed: () {
                    if(formkey.currentState!.validate()){
                      var title = titlecontroller.text;
                      var amount = amountcontroller.text;
                      
                      //เตรียมข้อมูล
                      Transactions statement = Transactions(
                        title: title,
                        amount: double.parse(amount),
                        date: DateTime.now()
                      );//object
                      
                      //เรียก provider
                      var provider = Provider.of<TransactionProvider>(context,listen: false);
                      provider.addTransaction(statement);
                      Navigator.pop(context);
                    }
                  
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
