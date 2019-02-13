import 'package:bits_fuser/ui/about_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' as DragStartBehavior;
import './models/memo_model.dart';
import './utils/database_helper.dart';
import './ui/create_memo.dart';
import './ui/verify_memo.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() async {
//  Brightness brightness;
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  brightness = (prefs.getBool("isDark") ?? false) ? Brightness.dark: Brightness.light;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bits Fuser',
      theme: new ThemeData(
        brightness: Brightness.dark,
        // new
      ),
      home: MyHomePage(
          title: 'Bits Fuser',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _dialVisible = true;
  var memos = List();
  var db;
  var memo = new Map();

  @override
  void initState() {
    // When you launch a app void main is runs only once so to refresh again we made this
    _refreshDatabase();
    super.initState();
  }

   _refreshDatabase()async {
    db = new DatabaseHelper();
    var Memos = await db.getAllMemo();
    setState(() {
      memos = Memos;
    });
  }

  @override
  Widget build(BuildContext context) {
    memo['id'] = null;  memo['title'] = null; memo['input'] = null;
    memo['password'] = null;

    return Scaffold(
//      appBar: AppBar(title: Text(widget.title) ),
        appBar:  AppBar(
          title:Text(widget.title) ,
        backgroundColor: Colors.teal,
//          actions: <Widget>[
//            new IconButton(
//              icon: new Icon(Icons.more_vert),
//              onPressed: () {
//                //Navigator.pop(context);
//              },
//            ),
//          ],
        ),
//-------------------------------- Drawer --------------------------------------
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              curve: Curves.fastOutSlowIn,
              child: Text('Drawer Header'),

              decoration: BoxDecoration(
                color: Colors.teal,
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About app'),
              onTap: () {
                // Then close the drawer
                Navigator.pop(context);
                var route = new MaterialPageRoute(builder: (context) => AboutApp());
                Navigator.of(context).push(route);
              },
            ),
            new Divider(),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
//-------------------------------- BODY ----------------------------------------
      // Memo list view
      body:  Container(
          child: ListView.builder(
            itemCount: memos.length ,
            itemBuilder: (context, int index){
              final item = MemoModel.fromMap(memos[index]).title;
              return Dismissible(
                // Each Dismissible must contain a Key. Keys allow Flutter to uniquely identify Widgets
                key: Key(item),
                // We also need to provide a function that tells our app  what to do after an item has been swiped away.
                onDismissed:(direction){
                  // Remove the item from our data source.
                  // First delete from async operation then soft delete and update the list
                  deleteMemo(index);
                  setState(()  {
                    memos.removeAt(index);
                  });
                  // Then show a snack bar!
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("$item  Deleted ") , backgroundColor: Colors.red[800],));
                },
                // Show a red background as the item is swiped away
                background: Container(
                  color: Colors.red[800],
                  margin: EdgeInsets.fromLTRB(1, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child:Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
                child: ListTile(
                    title: Text('$item'),
                  leading: Icon(Icons.title),
                  onTap:(){
                    var route = new MaterialPageRoute(builder: (context) => VerifyMemo(memoData : memos[index] ));
                    Navigator.of(context).push(route);
                  }
                ),
              );
            },
          )
      ),
// ----------------------------- Add new memo ----------------------------------
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
         child: Icon(Icons.add),
        visible: _dialVisible,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.vpn_key , color: Colors.black,),
              backgroundColor: Colors.tealAccent,
              label: 'Key encrpytion ',
              labelStyle: TextStyle(color:Colors.black,fontSize: 18.0),
              onTap: () {
                memo['key'] = "password";
                var route = new MaterialPageRoute(builder: (context) => CreateMemo(memo : memo));
                Navigator.of(context).push(route);
                },
          ),
          SpeedDialChild(
            child: Icon(Icons.donut_small, color: Colors.black,),
            backgroundColor: Colors.tealAccent,
            label: 'Pattern encrpytion',
            labelStyle: TextStyle(color: Colors.black,fontSize: 18.0),
            onTap: () {
              memo['key'] = "pattern";
              var route = new MaterialPageRoute(builder: (context) => CreateMemo(memo : memo));
              Navigator.of(context).push(route);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.fingerprint, color: Colors.black,),
            backgroundColor: Colors.tealAccent,
            label: 'Fingerprint encrpytion',
            labelStyle: TextStyle(color: Colors.black,fontSize: 18.0),
            onTap: () {
              memo['key'] = "fingerprint";
              var route = new MaterialPageRoute(builder: (context) => CreateMemo(memo : memo));
              Navigator.of(context).push(route);
            },
          ),
        ],
      ),

    );
  }

  // Delete memo on swipe
  Future<int> deleteMemo(int index) async{
  return await db.deleteMemo(MemoModel.fromMap(memos[index]).id);
  }

} // End of class
