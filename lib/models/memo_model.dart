class MemoModel{

  String _title;
  String _input;
  String _key;
  int _id;

  MemoModel(this._title,this._input, this._key );
  MemoModel.map(dynamic obj){
    this._title=obj['title'];
    this._input=obj['input'];
    this._key = obj['key'];
    this._id=obj['id'];
  }

  String get title => _title;
  String get input => _input;
  String get key => _key;
  int get id => _id;

  Map<String, dynamic> toMap(){
    var map= new Map<String, dynamic>();
    map["title"]=_title;
    map["input"]=_input;
    map["key"]=_key;
    if(id!=null){
      map["id"]=_id;
    }
    return map;
  }

  MemoModel.fromMap(Map<String, dynamic> map) {
    this._title = map["title"];
    this._input = map["input"];
    this._key = map["key"];
    this._id=map["id"];
  }

}
