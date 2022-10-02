import 'package:flutter/material.dart';
import 'package:flutter_database/providers/transaction_provider.dart';
import 'package:flutter_database/screens/form_screen.dart';
import 'package:flutter_database/widget/dropdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'models/Transactions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return TransactionProvider();
        })
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'แอพบัญชีรายจ่าย'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Provider.of<TransactionProvider>(context, listen: false).initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Formscreen();
                  }));
                })
          ],
        ),
        body: Consumer(
          builder: (context, TransactionProvider provider, child) {
            var count = provider.transactions.length; //นับจำนวนข้อมูล
            if (count <= 0) {
              return Center(
                child: Column(
                  children: const [
                    Text(
                      "ไม่พบข้อมูล",
                      style: TextStyle(fontSize: 35),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  const DropdownButtonExample(),
                  (provider.filter.isEmpty)
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: count,
                          itemBuilder: (context, int index) {
                            Transactions data = provider.transactions[index];
                            return Card(
                              elevation: 5,
                              margin: const EdgeInsets.all(10.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: FittedBox(
                                    child: Text(data.amount.toString()),
                                  ),
                                ),
                                title: Text(data.title),
                                subtitle: Text(
                                    DateFormat("dd/MM/yyyy").format(data.date)),
                              ),
                            );
                          })
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: provider.filter.length,
                          itemBuilder: (context, int index) {
                            Transactions data = provider.filter[index];
                            return Card(
                              elevation: 5,
                              margin: const EdgeInsets.all(10.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: FittedBox(
                                    child: Text(data.amount.toString()),
                                  ),
                                ),
                                title: Text(data.title),
                                subtitle: Text(
                                    DateFormat("dd/MM/yyyy").format(data.date)),
                              ),
                            );
                          }),
                ],
              );
            }
          },
        ));
  }
}
