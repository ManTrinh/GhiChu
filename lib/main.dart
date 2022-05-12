// main.dart
//import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//import 'title_test.dart';
//import 'data_text.dart';
import 'login.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

void main() => runApp(PreventScreenShot());

/*class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TitleList()),
      ],
      child: MaterialApp(
        home: TexDataPage(),
      ),
    );
  }
}*/
class PreventScreenShot extends StatefulWidget {
  @override
  _PreventScreenShotState createState() => _PreventScreenShotState();
}

class _PreventScreenShotState extends State<PreventScreenShot>
    {
  Future _flagSecure() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future _clearFlags() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    super.initState();
    _flagSecure();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _clearFlags();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: HomeDataSave(),
      home: Login(),
    );
  }
}
