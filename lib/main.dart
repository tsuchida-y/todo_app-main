import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/item_add.dart';
import 'package:sqflite/sqflite.dart'; //DBの定義

Database? db; //DBのインスタンスはDatabaseで定義します
// ignore: prefer_typing_uninitialized_variables
var controller;

Future<void> main() async {
  debugPrint("初期化前");
  WidgetsFlutterBinding.ensureInitialized();
  db = await openDatabase(
    'example.db', //example.dbという名前のデータベースを開く
    version: 1, // onCreateを指定する場合はバージョンを指定する
    onCreate: (db, version) async {//データベースが初めて作成されるときに呼び出されるコールバック関数
      //SQLiteデータベースが初めて作成されるときに呼び出される関数
      await db.execute(
        //与えられた SQL 文をデータベース上で実行します。
        'CREATE TABLE IF NOT EXISTS todos ('
        '  id INTEGER PRIMARY KEY AUTOINCREMENT,' //AUTOINCREMENT=主キーの値を自動で設定
        '  content TEXT,'
        '  created_at INTEGER'
        ')',
      );
    },
  );
  debugPrint("初期化あと");
  runApp(const MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  const MyTodoApp({super.key}); 

  @override //オーバーライド:親クラスのメソッドを子クラスで再定義すること
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,// 右上に表示される"debug"ラベルを消す
      title: 'My Todo App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // リスト一覧画面を表示
      home: const TodoListPage(),
    );
  }
}

// リスト一覧画面用Widget
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key}); //super:サブクラスから親クラスにアクセスするときに使用

  @override
  TodoListPageState createState() => //=>は右の結果を左に返す
      TodoListPageState(); //createStateはビルド後に呼ばれるメソッドで必須
}

class TodoListPageState extends State<TodoListPage> {
  late Future<List<Map<String, Object?>>>? todoListQuery;
  int selectedTabIndex = 0; //タブの選択状態を保持する変数
  List<String> todoList = [];


  @override
  void initState() {//StatefulWidgetで使用されるウィジェットの初期化時に呼び出されるメソッドです
    super.initState();
    controller =
        StreamController<int>(); //StreamControllerというクラスのインスタンスを作成するコード
    debugPrint("押した後");
    // タブごとに異なるクエリを実行
  }


  @override
  void dispose() {//Widgetがツリーから削除された時に呼び出される
    //ウィジェットやオブジェクトが不要になったときに、それらを解放しリソースをクリーンアップするためのメソッド
    controller.close(); //ストリームの終了やリソースの解放を行うためのメソッド
    super.dispose();
  }


  void _updateData() {
    controller.add(1); //ストリームにデータを追加する
  }

  

  @override
  Widget build(BuildContext context) {
    // build メソッド内でクエリを設定
    switch (selectedTabIndex) {
      //ここから
      case 0:
        todoListQuery = db?.query(
          'todos',
          where: 'content LIKE ?',
          whereArgs: ['%%'], //全てのレコードを取得
          orderBy: 'created_at DESC',
        );
        break;
      case 1:
        todoListQuery = db?.query(
          'todos',
          where: 'content LIKE ?',
          whereArgs: ['%%'],
          orderBy: 'created_at DESC',
        );
        break;
      case 2:
        todoListQuery = db?.query(
          'todos',
          where: 'content LIKE ?',
          whereArgs: ['%%'],
          orderBy: 'created_at DESC',
        );
        break;
    } 



    return DefaultTabController(//タブの状態を管理するためのWidget
      length: 3,
      child: Scaffold(

        // AppBarを表示し、タイトルも設定
        appBar: AppBar(
          bottom: TabBar(
            tabs: const <Widget>[
              Tab(text: '卓球'),
              Tab(text: 'サッカー'),
              Tab(text: 'テニス'),
            ],
            onTap: (index) {//indexはタップされたタブのインデックス(卓球なら0,サッカーなら1)
              setState(() {
                selectedTabIndex = index; //タブが選択されたときに変数を更新
              });
            },
          ),
          title: const Text('リスト'),
        ),



        // データを元にListViewを作成
        body: Column(
          children: [


            ElevatedButton(//検索ボタン
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(20, 20),
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(2),
              ),
              child: const Text("検索バー"),
            ),



            Expanded(//残りのスペースを埋める
              child: StreamBuilder(//データを監視して、更新されるたびにWidgetを再構築する
                  stream: todoListQuery!.asStream(),//監視するストリームを指定
                  builder: (context, snapshot) {//ストリームのデータを元にWidgetを構築
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(//スクロール可能なリストを作成
                        shrinkWrap: true, 
                        itemCount:snapshot.data!.length,//リストのアイテムの数
                        itemBuilder: (context, index) {//リストのアイテムを作成
                          return Card(
                            child: ListTile(
                              title: Text(snapshot.data?[index]["content"].toString() ?? "エラー"),//左がnullの場合右を返す
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      debugPrint("haser called");
                      return const Text("エラー");
                    }
                    debugPrint("progress called");
                    return const CircularProgressIndicator(); 
                  }),
            )
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {//新しいページを作成する
                return TodoAddPage(tabIndex: selectedTabIndex);//新しいページにデータを渡す
              }),
            ).then((value) {//pushメソッドが完了した後に呼び出されるコールバック
              _updateData();//データを更新
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}


