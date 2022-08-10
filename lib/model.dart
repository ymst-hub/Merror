
// テーブルの定義
import 'dbhelper.dart';

class Hozon {
  int? id;
  String hurikaeriTxt;
  String asueTxt;
  int? time;
  String timeStamp;

  Hozon({
    this.id,
    required this.hurikaeriTxt,
    required this.asueTxt,
    this.time,
    required this.timeStamp,
  });

// 更新時のデータを入力項目からコピーする処理
  Hozon copy({
    int? id,
    String? hurikaeriTxt,
    String? asueTxt,
    int? time,
    String? timeStamp,
  }) =>
      Hozon(
        id: id ?? this.id,
        hurikaeriTxt: hurikaeriTxt ?? this.hurikaeriTxt,
        asueTxt: asueTxt ?? this.asueTxt,
        time: time ?? this.time,
        timeStamp: timeStamp ?? this.timeStamp,
      );

  static Hozon fromJson(Map<String, Object?> json) => Hozon(
    id: json[columnId] as int,
    hurikaeriTxt: json[columnHurikaeriTxt] as String,
    asueTxt: json[columnAsueTxt] as String,
    time: json[columnTime] as int,
    timeStamp: json[columnTimeStamp] as String,
  );

  Map<String, Object> toJson() => {
    columnHurikaeriTxt: hurikaeriTxt,
    columnAsueTxt: asueTxt,
    columnTime: time.toString(),
    columnTimeStamp:timeStamp,
  };
}