
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class TodoAddPage extends StatefulWidget {
  final int tabIndex; 
  const TodoAddPage({Key? key, required this.tabIndex}) : super(key: key);

  @override
  TodoAddPageState createState() => TodoAddPageState();
}

class TodoAddPageState extends State<TodoAddPage> {
  String _inputText = '';

  @override
  Widget build(BuildContext context) {
    // タブの選択状態を使って適切な処理を行う
    // switch (widget.tabIndex) {
    //   case 0:
    //     debugPrint("卓球");
    //     // 卓球の処理
    //     break;
    //   case 1:
    //     debugPrint("サッカー");
    //     // サッカーの処理
    //     break;
    //   case 2:
    //     debugPrint("テニス");
    //     // テニスの処理
    //     break;
    //   default:
    //     break;
    // }
    return Scaffold(

      appBar: AppBar(
        title: const Text('リスト追加'),
      ),

      body: Container(
        padding: const EdgeInsets.all(64), // 余白をつける
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 入力されたテキストを表示
            Text(_inputText, style: const TextStyle(color: Colors.blue)),
            const SizedBox(height: 8),
            // テキスト入力
            TextField(
              // 入力されたテキストの値を受け取る（valueが入力されたテキスト）
              onChanged: (String value) {
                //ユーザーが特定の入力フィールドに対して入力を行った際に発火されるコールバック
                // データが変更したことを知らせる（画面を更新する）
                setState(() {
                  // データを変更
                  _inputText = value;
                });
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              // 横幅いっぱいに広げる
              width: double.infinity,
              // リスト追加ボタン
              child: ElevatedButton(
                onPressed: () async {
                  await db?.insert(
                    //DBに保存
                    'todos', // テーブル名
                    {
                      'content': _inputText, // カラム名: 値
                      'created_at': DateTime.now()
                          .millisecondsSinceEpoch, //データベースに新しいレコードを挿入する際に、そのレコードが作成された日時を表すための情報を設定しています。
                    },
                  ).then((value) => Navigator.of(context).pop(_inputText)); //.then
                },
                child:
                    const Text('リスト追加', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              // 横幅いっぱいに広げる
              width: double.infinity,
              // キャンセルボタン
              child: TextButton(
                onPressed: () {
                  // ボタンをクリックした時の処理
                  Navigator.of(context).pop(); // "pop"で前の画面に戻る
                },
                child: const Text('キャンセル'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}