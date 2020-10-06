class Note {

  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title,this._date,this._priority,[this._description]);
  Note.withId(this._title,this._date,this._priority,[this._description]);

  int get priority => _priority;

  // ignore: unnecessary_getters_setters
  String get date => _date;

  String get description => _description;

  String get title => _title;

  int get id => _id;

  set priority(int value) {
    if(value>=1 && value<=2) {
      _priority = value;
    }
  }

  // ignore: unnecessary_getters_setters
  set date(String value) {
    _date = value;
  }

  set description(String value) {
    if(value.length<=255) {
      _description = value;
    }
  }

  set title(String value) {
    if(value.length<=255) {
      _title = value;
    }
  }


  // //convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map=Map<String, dynamic>();
    if(id!=null){
      map['id']=_id;
    }

      map['title']=_title;
      map['description']=_description;
      map['priority']=_priority;
      map['date']=_date;
      return map;

  }

  // Extract a note object from a map object

  Note.fromMapObject(Map<String, dynamic> map){

    this._id=map['id'];
    this._title=map['title'];
    this._description=map['description'];
    this._priority=map['priority'];
    this._date=map['date'];
  }
}