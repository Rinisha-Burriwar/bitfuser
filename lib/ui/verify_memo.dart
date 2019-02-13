import 'package:bits_fuser/main.dart';
import 'package:flutter/material.dart';
import '../utils/memo_helper.dart';
import '../ui/create_memo.dart';

class VerifyMemo extends StatefulWidget{
  final memoData;
  VerifyMemo({Key key,   this.memoData }) : super(key: key);
  @override
  _VerifyMemoState createState() => _VerifyMemoState();
}

class _VerifyMemoState  extends State<VerifyMemo>  {

  TextEditingController passwordController = TextEditingController();
  MemoHelper memoHelper = new MemoHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  var dialogTitle = "Verify your password";
  String _password;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //print(widget.memoData);
    var ui ;
    switch(widget.memoData['key']){
      case "password":{
        ui = KeyUi();
        break;
      }
      case "plain":{
        ui = PlainUi();
        break;
      }
      case "fingerprint":{
        ui = FingerPrintUi();
        break;
      }
    }

    return  Scaffold(
      appBar: AppBar(
        title: Text(dialogTitle ,style: TextStyle(color: Colors.tealAccent),),
      ),
      body: ui ,
    );
  }

  Widget KeyUi() {
    return new Container(
      margin: new EdgeInsets.all(15.0),
      child: new Form(
        key: _formKey,
        autovalidate: _autoValidate,
          child: new Column(
              children: <Widget>[
                const SizedBox(height: 24.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  validator: validatePassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: Icon(Icons.remove_red_eye),
                      suffixStyle: TextStyle(color: Colors.green)
                  ),
                  maxLines: 1,
                  maxLength: 26,
                  onSaved: (String val) {
                    _password = val;
                  },
                ),
                const SizedBox(height: 24.0),
                RaisedButton(
                  child: Text('Check'),
                  color: Colors.teal,
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  textColor: Colors.white,
                  elevation: 4.0,
                  splashColor: Colors.blue[300],
                  onPressed: (){
                    _validateInputs();
                  },
                ),
              ]
          ),
      ),
    );
  }

  Widget PlainUi(){
    return Text("plain");
  }

  Widget FingerPrintUi(){

    return Text("Finger print");
  }

  String validatePassword(String value) {
    if (value.length < 5)
      return 'Name must be more than 5 characters';
    else
      return null;
  }

  void _validateInputs() async {
    if (_formKey.currentState.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState.save();
      // If you Here means all things have been validated , save to Db , //_password
      var result =  await memoHelper.validate(widget.memoData["input"], _password);

      if(result[0])
        {
          var map = Map();
          map ["id"] = widget.memoData["id"];
          map ["title"] = widget.memoData["title"];
          map["input"] = result[1];
          map["password"] = _password;
          map["key"] = widget.memoData["key"];
          print(map);
          var route = new MaterialPageRoute(builder: (context) => CreateMemo(memo: map));
          Navigator.of(context).push(route);
      }
      else{
        setState(() {
          dialogTitle = "Invalid password";
        });
      }
    }
    else {
      //If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

}//End of class






