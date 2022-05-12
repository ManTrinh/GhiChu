import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'title_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TexDataPage extends StatefulWidget {
  const TexDataPage({Key? key}) : super(key: key);

  @override
  _TexDataPageState createState() => _TexDataPageState();
}

class _TexDataPageState extends State<TexDataPage> {
  // This variable holds the list's items
  final List<objTextData> _todos = [];
  List<objTextData> _todosFiltered = [];
  List<String> _saveData = [];
  String _searchResult = '';
  int _nIdx = 0;
  bool edit = false;
  TextEditingController controller = TextEditingController();

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      List<String> NullList = [];
      _saveData = prefs.getStringList('NewDataText') ?? NullList;
      if (_saveData.length > 0 && _todos.length == 0) {
        _todos.clear();
        //print(_saveData.join());
        for (int i = 0; i < _saveData.length; i++) {
          List<String> s = _saveData[i].split(",");
          objTextData elementData = objTextData(s[0], s[1], s[2], s[3]);
          _todos.add(elementData);
        }
      }
    });
  }

  void _SaveData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // save ok
      List<String> dataText = _saveData;
      prefs.setStringList('NewDataText', dataText);
      //prefs.remove('DataText');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _todosFiltered = _todos;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {
              setState(() {
                FocusManager.instance.primaryFocus?.unfocus();
                edit = false;
              })
            },
        child: WillPopScope(
            onWillPop: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Không thể quay về trước')));
              return false;
            },
            child: Scaffold(
                backgroundColor: Colors.red.shade100,
                body: Column(
                  children: [
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
                                          image: AssetImage(
                                              "assets/images/Boy.png"))),
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
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: new ListTile(
                              leading: new Icon(Icons.search),
                              title: new TextField(
                                  controller: controller,
                                  decoration: new InputDecoration(
                                      hintText: 'Search',
                                      border: InputBorder.none),
                                  onChanged: (value) {
                                    setState(() {
                                      _searchResult = value;
                                      //RegExp regEx = new RegExp(r"(?=.*[a-z])(?=.*[A-Z])\w+");
                                      _todosFiltered = _todos
                                          .where((data) => data.getTitle.toUpperCase()
                                              .contains(_searchResult.toUpperCase()))
                                          .toList();
                                    });
                                  }),
                              trailing: new IconButton(
                                icon: new Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    controller.clear();
                                    _searchResult = '';
                                    _todosFiltered = _todos;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          child: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 30.0,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(360.0),
                            ),
                            primary: Colors.orange.shade600, // background
                            onPrimary: Colors.black, // foreground
                          ),
                          onPressed: () {
                            setState(() {
                              _todosFiltered = _todos;
                              objTextData tmp = objTextData("", "", "", "");
                              _todos.insert(_todos.length, tmp);
                              //_nIdx++;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Chủ đề",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black, //font color
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Url",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black, //font color
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Tài khoản",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black, //font color
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Mật khẩu",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black, //font color
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ReorderableListView(
                          children: _todosFiltered
                              .map((task) => Container(
                                    key: ValueKey(task),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                        ),
                                        color: Colors.orange.shade100,
                                        border: Border.all(
                                            width: 1, color: Colors.white)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            initialValue: task.getTitle,
                                            //controller: TextEditingController(text: task.getTitle),
                                            enabled: edit,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                //hintText: task.getTitle,
                                                hintStyle: TextStyle(
                                                    color: Colors.black)),
                                            onEditingComplete: () {
                                              // After editing is complete, make the editable false
                                              setState(() {
                                                edit = !edit;
                                              });
                                            },
                                            onChanged: (newVal) {
                                              setState(() {
                                                task.newTilte = newVal;
                                              });
                                              //print(task.getTitle);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            initialValue: task.getUrl,
                                            //controller: TextEditingController(text: task.getTitle),
                                            enabled: edit,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                //hintText: task.getTitle,
                                                hintStyle: TextStyle(
                                                    color: Colors.black)),
                                            onEditingComplete: () {
                                              // After editing is complete, make the editable false
                                              setState(() {
                                                edit = !edit;
                                              });
                                            },
                                            onChanged: (newVal) {
                                              setState(() {
                                                task.newUrl = newVal;
                                              });
                                              //print(task.getTitle);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            initialValue: task.getAccount,
                                            //controller: TextEditingController(text: task.getTitle),
                                            enabled: edit,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                //hintText: task.getTitle,
                                                hintStyle: TextStyle(
                                                    color: Colors.black)),
                                            onEditingComplete: () {
                                              // After editing is complete, make the editable false
                                              setState(() {
                                                edit = !edit;
                                              });
                                            },
                                            onChanged: (newVal) {
                                              setState(() {
                                                task.newAccount = newVal;
                                              });
                                              //print(task.getTitle);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            textAlign: TextAlign.center,
                                            initialValue: task.getPasswords,
                                            //controller: TextEditingController(text: task.getTitle),
                                            enabled: edit,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                //hintText: task.getTitle,
                                                hintStyle: TextStyle(
                                                    color: Colors.black)),
                                            onEditingComplete: () {
                                              // After editing is complete, make the editable false
                                              setState(() {
                                                edit = !edit;
                                              });
                                            },
                                            onChanged: (newVal) {
                                              setState(() {
                                                task.newPassword = newVal;
                                              });
                                              //print(task.getTitle);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          // The reorder function
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              final element = _todosFiltered.removeAt(oldIndex);
                              _todosFiltered.insert(newIndex, element);
                            });
                          }),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            primary: Colors.orange.shade600, // background
                            onPrimary: Colors.black, // foreground
                          ),
                          child: Text('Sửa'),
                          onPressed: () {
                            // When edit is pressed, make the editable true
                            setState(() {
                              edit = !edit;
                            });
                          },
                        )),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(360.0),
                              ),
                              primary: Colors.orange.shade600, // background
                              onPrimary: Colors.black, // foreground
                            ),
                            onPressed: () {
                              // When edit is pressed, make the editable true
                              setState(() {
                                _saveData.clear();
                                _todosFiltered = _todos;
                                int nCnt = 0;
                                for (int i = 0; i < _todos.length; i++) {
                                  nCnt = 0;
                                  if (_todos[i].getTitle.isEmpty) {
                                    nCnt++;
                                  }
                                  if (_todos[i].getUrl.isEmpty) {
                                    nCnt++;
                                  }
                                  if (_todos[i].getAccount.isEmpty) {
                                    nCnt++;
                                  }
                                  if (_todos[i].getPasswords.isEmpty) {
                                    nCnt++;
                                  }
                                  String sValue = _todos[i].getTitle +
                                      "," +
                                      _todos[i].getUrl +
                                      "," +
                                      _todos[i].getAccount +
                                      "," +
                                      _todos[i].getPasswords;
                                  if (nCnt < 4) {
                                    _saveData.add(sValue);
                                  }
                                }
                                print(_saveData.join("/"));
                                FocusManager.instance.primaryFocus?.unfocus();
                                edit = false;
                                _SaveData();
                                controller.clear();
                                _searchResult = '';
                                _todosFiltered = _todos;
                              });
                            },
                            child: const Text('Lưu'),
                          ),
                        ),
                      ],
                    )
                  ],
                ))));
  }
}
