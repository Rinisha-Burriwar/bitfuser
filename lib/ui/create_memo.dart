import 'package:bits_fuser/models/memo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

import '../main.dart';
import '../utils/memo_helper.dart';

class CreateMemo extends StatefulWidget {
  final memo;
  CreateMemo({Key key, this.memo}) : super(key: key);
  @override
  _CreateMemoState createState() => _CreateMemoState();
}

class _CreateMemoState  extends State<CreateMemo> {

  final titleController = TextEditingController();
  final inputController = TextEditingController();
  final passwordController = TextEditingController();
  MemoHelper memoHelper = new MemoHelper();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String _title;
  String _input;
  String _password;
  bool notVisibile = true;
  bool update = false;

  @override
  void initState() {
    if(widget.memo["input"] != null){
      titleController.text = widget.memo["title"];
      inputController.text = widget.memo["input"];
      passwordController.text = widget.memo["password"];
      update = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    titleController.dispose();
    inputController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // TODO: implement Create memo build
      var ui ;
      switch(widget.memo["key"]){
        case "password":{
          ui = KeyUi();
          break;
        }
        case "pattern":{
          ui = PatternUi();
          break;
        }
        case "fingerprint":{
          ui = FingerPrintUi();
          break;
        }
      }

      return Scaffold(
      appBar: AppBar(
        title: Text("Create memo"),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
        ),
        // Back to home page button (x)
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () {
              //Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
        ],
      ),
        body: SingleChildScrollView(
        child: new Container(
        margin: new EdgeInsets.all(15.0),
        child: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 24.0),
              TextFormField(
                keyboardType: TextInputType.text,
                controller:titleController,
                //validator: validateTitle,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Memo title',
                    suffixIcon: Icon(Icons.title),
                    suffixStyle: TextStyle(color: Colors.green)
                ),
                maxLines: 1,
                maxLength: 26,
                onSaved: (String val){setState(() {_title =  val;});},

              ),
              const SizedBox(height: 24.0),
              TextFormField(
                keyboardType: TextInputType.text,
                controller:inputController,
                //validator: validateInput,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Secret memo',
                    suffixIcon: Icon(Icons.description),
                    suffixStyle: TextStyle(color: Colors.green)
                ),
                maxLines: 4,
                maxLength: 256,
                //onChanged: (String val){inputController.text = val;},
                onSaved: (String val){_input = val;},
              ),
              ui,
            ],
          ),
              ),
          ),
        ),
    );
  }

  Widget KeyUi() {
    return new Column(
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.text,
          obscureText: notVisibile,
          controller:passwordController,
          validator: validatePassword,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              suffixIcon: Icon(Icons.remove_red_eye),
              suffixStyle: TextStyle(color: Colors.green)
          ),
          maxLines: 1,
          maxLength: 26,
          onSaved: (String val){_password = val;},
        ),
        const SizedBox(height: 24.0),
        RaisedButton(
          child: Text('Save'),
          color: Colors.teal,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
          textColor: Colors.white,
          elevation: 4.0,
          splashColor: Colors.blue[300],
          onPressed: (){
            _validateInputs();
          },
        ),
      ],
    );
  }

  Widget PatternUi(){
    return Text("Pattern");
  }

  Widget FingerPrintUi(){
    return  Column(
      children: <Widget>[
        const SizedBox(height: 24.0),
        FloatingActionButton.extended(
         label: Text('Scan fingerprint' , style: TextStyle(color: Colors.white),),
          icon: Icon(Icons.fingerprint,color : Colors.white ,),
          backgroundColor: Colors.teal,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
          elevation: 4.0,
          onPressed: (){
            _validateInputs();
          },
        ),
      ],
      
    );
  }

  String validateTitle(String value) {
    if (value.length < 3)
      return 'Name must be more than 3 characters';
    else
      return null;
  }

  String validateInput(String value) {
    if (value.length < 3)
      return 'Name must be  3 characters';
    else
      return null;
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
      bool didAuthenticate = false;

      switch(widget.memo["key"]){
        case "password":{
          didAuthenticate = true;
          break;
        }
        case "pattern":{
          break;
        }
        case "fingerprint":{
          var localAuth = LocalAuthentication();
          didAuthenticate =
          await localAuth.authenticateWithBiometrics(
              localizedReason: 'Please place your hand on fingerprint sensor');
          break;
        }
      }

      if(didAuthenticate ){
        if(update){
          var memo = new Map();
          memo['id'] = widget.memo["id"];
          memo['title'] = _title;
          memo['input'] = _input;
          memo['key'] = widget.memo["key"];
          memo['password'] = widget.memo["password"];
          memoHelper.update(memo);
        }
        else{
          memoHelper.save(_title,_input,_password,widget.memo["key"]);
        }
        var route = new MaterialPageRoute(builder: (context) =>MyApp());
        Navigator.of(context).push(route);
//        Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context) => MyApp()),
//        );

      }
      else{
        SnackBar(content: Text("Please try again") , backgroundColor: Colors.red[800],);
      }

    }
     else {
      //If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

}// End of CreateMemo

