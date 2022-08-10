import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

// Hozonテーブルのカラム名を設定
const String columnId = '_id';
const String columnHurikaeriTxt = 'hurikaeriTxt';
const String columnAsueTxt = 'asueTxt';
const String columnTime = 'time';
const String columnTimeStamp = 'timeStamp';


// Hozonテーブルのカラム名をListに設定
const List<String> columns = [
  columnId,
  columnHurikaeriTxt,
  columnAsueTxt,
  columnTime,
  columnTimeStamp,
];

// Hozonテーブルへのアクセスをまとめたクラス
class DbHelper {
  // DbHelperをinstance化する
  static final DbHelper instance = DbHelper._createInstance();
  static Database? _database;

  DbHelper._createInstance();

  // databaseをオープンしてインスタンス化する
  Future<Database> get database async {
    return _database ??= await _initDB();       // 初回だったら_initDB()=DBオープンする
  }

  // データベースをオープンする
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'Memo.db');    // Hozon.dbのパスを取得する

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,      // Hozon.dbがなかった時の処理を指定する（DBは勝手に作られる）
    );
  }

  // データベースがなかった時の処理
  Future _onCreate(Database database, int version) async {
    //Hozonテーブルをcreateする
    await database.execute('''
      CREATE TABLE Hozon(
        _id INTEGER PRIMARY KEY AUTOINCREMENT,
        hurikaeriTxt TEXT,
        asueTxt TEXT,
        time INTEGER,
        timeStamp TEXT
      )
    ''');
  }

  // Hozonテーブルのデータを全件取得する
  Future<List<Hozon>> selectAllData() async {
    final db = await instance.database;
    final hozonData = await db.query('Hozon');          // 条件指定しないでHozonテーブルを読み込む

    return hozonData.map((json) => Hozon.fromJson(json)).toList();    // 読み込んだテーブルデータをListにパースしてreturn
  }

// _idをキーにして1件のデータを読み込む
  Future<Hozon> hozonData(int id) async {
    final db = await instance.database;
    var hozon = [];
    hozon = await db.query(
      'Hozon',
      columns: columns,
      where: '_id = ?',                     // 渡されたidをキーにしてHozonテーブルを読み込む
      whereArgs: [id],
    );
    return Hozon.fromJson(hozon.first);      // 1件だけなので.toListは不要
  }

// データをinsertする
  Future insert(Hozon hozon) async {
    final db = await database;
    return await db.insert(
        'Hozon',
        hozon.toJson()                         // Hozon_model.dartで定義しているtoJson()で渡されたmemoをパースして書き込む
    );
  }

// データをupdateする
  Future update(Hozon hozon) async {
    final db = await database;
    return await db.update(
      'Hozon',
      hozon.toJson(),
      where: '_id = ?',                   // idで指定されたデータを更新する
      whereArgs: [hozon.id],
    );
  }

// データを削除する
  Future delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'Hozon',
      where: '_id = ?',                   // idで指定されたデータを削除する
      whereArgs: [id],
    );
  }

}