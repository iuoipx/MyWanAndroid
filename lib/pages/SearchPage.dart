import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../services/ScreenAdapter.dart';
import '../api/Api.dart';
import '../models/HotKeyModel.dart';
import 'package:dio/dio.dart';
import '../services/SearchService.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List <HotKeyItemModel> _hotKeyData=[]; //搜索热门
  List _historyListData=[];  //搜索历史
  var _keywords;

  //获取搜索热门数据
  _getHotKey() async{
    var api=Api.hotKey;
    var result=await Dio().get(api);
    HotKeyModel hotKeyList=HotKeyModel.fromJson(result.data);
    setState(() {
      this._hotKeyData=hotKeyList.data;
    });
  }

  //获取历史记录数据
  _getHistoryData() async{
    var historyListData=await SearchService.getHistoryData();
    setState(() {
      this._historyListData=historyListData;
    });
  }

  @override
  void initState() {
    super.initState();
    this._getHotKey();
    this._getHistoryData();
  }

  @override
  void dispose() {
    super.dispose();
    this._keywords='';
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,  //设置没有返回按钮
        title: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: ScreenAdapter.height(60)
          ),
          child: TextField(
            // onChanged: (value){
            //   setState(() {
            //     this._keywords=value;
            //   });
            // },
            onSubmitted: (value){
              setState(() {
                this._keywords=value;
              });
              SearchService.setHistoryData(this._keywords);
              Navigator.pushReplacementNamed(context, '/searchResult',arguments: {'keywords':'${this._keywords}'});
            },
            textAlign: TextAlign.start,
            cursorColor: Colors.grey,
            cursorWidth: 1,
            maxLines: 1,
            style: TextStyle(fontSize: ScreenAdapter.size(28), color: Colors.black87),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 4),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black38,
                size: ScreenAdapter.size(40),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              hintText: " 输入搜索内容"
            ),
          ),
        ),
        actions: <Widget>[
          Center(
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(right: ScreenAdapter.width(24)),
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(ScreenAdapter.width(20), ScreenAdapter.width(40), 0, ScreenAdapter.width(10)),
                child: Text(
                  '搜索历史',
                  style: Theme.of(context).textTheme.title
                ),
              ),
              this._historyListData.length>0
                ?GestureDetector(
                  onTap: (){
                    SearchService.clearHistoryData();
                    this._getHistoryData();
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(ScreenAdapter.width(20), ScreenAdapter.width(48), ScreenAdapter.width(20), ScreenAdapter.width(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.restore_from_trash,
                          color: Colors.black38,
                          size: ScreenAdapter.size(32),
                        ),
                        Text(
                          '清空',
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: ScreenAdapter.size(26)
                          ),
                        )
                      ],
                    ),
                  ),
                )
                :Container(width: 0,height: 0,)
            ],
          ),
          Wrap(
            children: this._historyListData.reversed.map((value){
              return GestureDetector(
                onTap: (){
                  setState(() {
                    this._keywords=value;
                  });
                  SearchService.setHistoryData(this._keywords);
                  Navigator.pushReplacementNamed(context, '/searchResult',arguments: {'keywords':'${this._keywords}'});
                },
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: ScreenAdapter.height(50)
                  ),
                  margin: EdgeInsets.fromLTRB(ScreenAdapter.width(20), ScreenAdapter.width(12), 0, 0),
                  padding: EdgeInsets.fromLTRB(ScreenAdapter.width(20), ScreenAdapter.width(10), ScreenAdapter.width(20), ScreenAdapter.width(10)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Color.fromRGBO(233, 233, 233, 0.7)
                  ),
                  child: Text(
                    '${value+''}',
                    style: TextStyle(
                      fontSize: ScreenAdapter.size(28),
                      color: Colors.black54
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(ScreenAdapter.width(20), ScreenAdapter.width(30), 0, ScreenAdapter.width(20)),
            child: Text(
              '热门搜索',
              style: Theme.of(context).textTheme.title
            ),
          ),
          Column(
            children: this._hotKeyData.map((value){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      setState(() {
                        this._keywords=value.name;
                      });
                      SearchService.setHistoryData(this._keywords);
                      Navigator.pushReplacementNamed(context, '/searchResult',arguments: {'keywords':'${this._keywords}'});
                    },
                    child: Container(
                      width: ScreenAdapter.width(750),
                      margin: EdgeInsets.fromLTRB(ScreenAdapter.width(20), ScreenAdapter.width(24), 0, ScreenAdapter.width(24)),
                      child: Text(
                        '${value.name}',
                        style: TextStyle(
                          fontSize: ScreenAdapter.size(28),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black26,
                    height: 0,
                  )
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}