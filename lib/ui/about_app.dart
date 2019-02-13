import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AboutApp extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(" About App"),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        margin: new EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            new ListTile(
              leading: Icon(Icons.person),
              title: new Text('Made by Chid chid' ,  style:  TextStyle(fontSize: 18),),
            ),
            new ListTile(
              leading: Icon(Icons.featured_play_list),
              title: new Text('App Features developed' ,  style:  TextStyle(fontSize: 18),),
            ),
            new ListTile(
              leading: MyBullet(),
              title: new Text('Made with Flutter ❤ and MVC UI layout design' ,  style:  TextStyle(fontSize: 18),),
            ),
            new ListTile(
              leading: MyBullet(),
              title: new Text('AES String Encpyrtion + salt' ,  style:  TextStyle(fontSize: 18),),
            ),
            new ListTile(
              leading: MyBullet(),
              title: new Text('Localized Database' ,  style:  TextStyle(fontSize: 18),),
            ),
            new ListTile(
              leading: MyBullet(),
              title: new Text('No logs track and easy update' ,  style:  TextStyle(fontSize: 18),),
            ),
            new ListTile(
              leading: MyBullet(),
              title: new Text('Swipe to delete gesture' ,  style:  TextStyle(fontSize: 18),),
            ),
          ],
        ),
      ),
    );
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 16.0,
      width: 16.0,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
//class _AboutAppState extends State<AboutApp>
//{
//  
//}