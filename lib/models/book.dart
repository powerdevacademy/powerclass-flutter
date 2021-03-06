/// id : "x"
/// cover : "x"
/// title : "x"
/// author : "x"
/// isRead : false
/// rate : 5

class Book {
  String _id;
  String _cover;
  String _title;
  String _author;
  bool _isRead;
  int _rate;
  String _uid;

  //transiente
  String url;

  String get id => _id;
  String get cover => _cover;
  String get title => _title;
  String get author => _author;
  bool get isRead => _isRead;
  int get rate => _rate;
  String get uid => _uid;

  Book({
      String id, 
      String cover, 
      String title, 
      String author, 
      bool isRead, 
      int rate,
      String uid}){
    _id = id;
    _cover = cover;
    _title = title;
    _author = author;
    _isRead = isRead;
    _rate = rate;
    _uid = uid;
  }

  Book.fromJson(dynamic json) {
    _id = json["id"];
    _cover = json["cover"];
    _title = json["title"];
    _author = json["author"];
    _isRead = json["isRead"];
    _rate = json["rate"]?.round();
    _uid = json["uid"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["cover"] = _cover;
    map["title"] = _title;
    map["author"] = _author;
    map["isRead"] = _isRead;
    map["rate"] = _rate;
    map["uid"] = _uid;
    return map;
  }

}