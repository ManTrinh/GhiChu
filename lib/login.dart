import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_text.dart';
import 'main.dart';

class Login extends StatefulWidget {
  @override
  createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  TextEditingController PassCtrl = new TextEditingController();
  String sPassWord = "";
  bool bHavePass = false;
  bool _isHidden = true;

  void _loadPassWord() async {
    final prefs = await SharedPreferences.getInstance();
    //List<String> NullList = [];
    setState(() {
      sPassWord = prefs.getString('NewDataTextPass') ?? "";
    });
  }

  void _SavePassWord() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('NewDataTextPass', PassCtrl.text);
      //prefs.remove('DataText');
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _loadPassWord();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('MyApp state = $state');
    if (state == AppLifecycleState.inactive) {
      // app transitioning to other state.
    } else if (state == AppLifecycleState.paused) {
      // app is on the background.
    } else if (state == AppLifecycleState.detached) {
      // flutter engine is running but detached from views
    } else if (state == AppLifecycleState.resumed) {
      // app is visible and running.
      print("1");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Login()));
    }
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Lỗi nhập liệu"),
      content: Text("Mật khẩu sai hoặc đang được để trống"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (sPassWord.isNotEmpty) {
      bHavePass = true;
    }
    return Scaffold(
        backgroundColor: Colors.red.shade100,
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                    height: 200,
                    child: Column(children: [
                      Image(
                          width: 200,
                          height: 100,
                          image: AssetImage("assets/images/MT-Design.png"),
                          fit: BoxFit.contain),
                      Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, //Center Row contents horizontally,
                          crossAxisAlignment: CrossAxisAlignment
                              .center, //Center Row contents vertically,
                          children: <Widget>[
                            Container(
                              width: 90.0,
                              height: 80.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.red.shade300,
                                      width: 10.0,
                                      style: BorderStyle.solid),
                                  image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          AssetImage("assets/images/Boy.png"))),
                            ),
                            Text('GHI CHÚ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ))
                          ]),
                    ])),
                Expanded(
                    child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red.shade100)),
                      child: TextField(
                        obscureText: _isHidden,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Mật khẩu",
                          suffix: InkWell(
                            onTap: _togglePasswordView,

                            /// This is Magical Function
                            child: Icon(
                              _isHidden
                                  ?

                                  /// CHeck Show & Hide.
                                  Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          /*icon: Icon(
                  Icons.password_sharp,
                  color: Colors.black,
                ),*/
                        ),
                        controller: PassCtrl,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: Text(
                              'ĐĂNG NHẬP',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            onPressed: bHavePass
                                ? () {
                                    if (PassCtrl.text.isEmpty) {
                                      showAlertDialog(context);
                                    } else if (PassCtrl.text != sPassWord) {
                                      showAlertDialog(context);
                                    } else if (PassCtrl.text == sPassWord) {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration:
                                                Duration(seconds: 1),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              return ScaleTransition(
                                                scale: animation,
                                                child: child,
                                                alignment: Alignment.center,
                                              );
                                            },
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return TexDataPage();
                                            },
                                          ));
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                                //fixedSize: Size(nBtnWidth, nBtnHeight),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                primary: Colors.orange.shade600,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            child: Text(
                              'TẠO MỚI',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            onPressed: bHavePass
                                ? null
                                : () {
                                    //print(PassCtrl.text);
                                    if (PassCtrl.text.isEmpty) {
                                      showAlertDialog(context);
                                    } else {
                                      _SavePassWord();
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration:
                                                Duration(seconds: 1),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              return ScaleTransition(
                                                scale: animation,
                                                child: child,
                                                alignment: Alignment.center,
                                              );
                                            },
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return TexDataPage();
                                            },
                                          ));
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                                //fixedSize: Size(nBtnWidth, nBtnHeight),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                primary: Colors.orange.shade600,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 20),
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ),
                        )
                      ],
                    )
                  ],
                )),
              ],
            )));
  }
}
