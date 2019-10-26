import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mywanandroid/models/ArticleModel.dart';
import 'package:mywanandroid/services/SearchService.dart';
import '../services/ScreenAdapter.dart';
import '../api/Api.dart';
import 'package:dio/dio.dart';
import '../widgets/ArticleListItem.dart';
import '../utils/StringUtil.dart';
import '../widgets/LoadingWidget.dart';

class SearchResult extends StatefulWidget {
  final Map arguments;
  SearchResult({Key key,this.arguments}) : super(key: key);

  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {

  List <ArticleItemModels> _articleData=[];  //搜索文章数据

  //上拉分页
  ScrollController _scrollController=new ScrollController();
  int _page=0;  //页码
  //每一页返回数据条数
  int _pageSize;
  //是否有数据
  bool _hasMore=true;
  //滑动到底请求数据完成之前不允许重复请求
  bool _flag=true;
  bool _searchRes=true;
  
  _getSearchData() async{
    setState(() {
      this._flag=false;
    });
    var api=Api.searchList+'${this._page}/json';
    FormData formData = new FormData.from({
      "k": "${this._words.text}",
    });
    var response=await Dio().post(api,data:formData);
    if(response.data['data']['datas'].length==0){
      setState(() {
        _searchRes=false;
      });
    }
    //print(response.data);
    ArticleModel articleList=ArticleModel.fromJson(response.data);
    //判断最后一页有没有数据
    this._pageSize=articleList.data.size;
    if(articleList.data.datas.length<this._pageSize){
      this._hasMore=false;
      setState(() {
        this._articleData.addAll(articleList.data.datas);
        this._page++;
        this._flag=true;
      });
    }else{
      setState(() {
        this._articleData.addAll(articleList.data.datas);
        this._page++;
        this._flag=true;
      });
    }
  }

  //获取文章列表最新数据
  _getRefreshSearchData() async{
    var api=Api.searchList+'0/json';
    FormData formData = new FormData.from({
      "k": "${this._words.text}",
    });
    var response=await Dio().post(api,data:formData);
    ArticleModel articleList=ArticleModel.fromJson(response.data);
    setState(() {
      this._articleData=articleList.data.datas;
    });
  }

  //判断商品列表底部进度条是否显示
  showMore(index){
    if(this._hasMore){
      return (index==this._articleData.length-1)
        ?SpinKitCircle (
          color: Colors.teal,
          size: 30,
        )
        :Container(height: 0,);
    }else{
      return (index==this._articleData.length-1)
        ?Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: Text('---已经到底了---',textAlign: TextAlign.center,),
        )
        :Container(height: 0,);
    }
  }

  Future<Null> _refresh() async {
    this._articleData.clear();
    await _getRefreshSearchData();
    return;
  }


  TextEditingController _words=TextEditingController();
  @override
  void initState() {
    super.initState();
    this._words.text=widget.arguments['keywords'];
    this._getSearchData();
    this._scrollController.addListener((){
      //_scrollController.position.pixels;  //滚动条已经滚动高度
      //_scrollController.position.maxScrollExtent;   //页面高度
      if(_scrollController.position.pixels>_scrollController.position.maxScrollExtent-10){
        if(this._flag&&this._hasMore){
          setState(() {
            this._getSearchData();
          });
        }
      }  
    });
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    this._words.dispose();
    super.dispose();
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
                this._words.text=value;
                _getRefreshSearchData();
              });
              SearchService.setHistoryData(this._words.text);
            },
            textAlign: TextAlign.start,
            cursorColor: Colors.grey,
            cursorWidth: 1,
            maxLines: 1,
            controller: this._words,
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
      body: this._articleData.length>0
        ?RefreshIndicator(
          onRefresh: _refresh,
          child: Container(
            color: Color.fromRGBO(233, 233, 233, 0.7),
            child: ListView.builder(
              controller: this._scrollController,
              itemCount: this._articleData.length,
              itemBuilder: (context,index){
                return Column(
                  children: <Widget>[
                    ArticleListItemWidget(
                      title: StringUtil.strClean(this._articleData[index].title),
                      time: this._articleData[index].niceDate,
                      author: this._articleData[index].author,
                      superChapterName: this._articleData[index].superChapterName,
                      chapterName: this._articleData[index].chapterName,
                      fresh: this._articleData[index].fresh,
                      onTap: (){
                        Navigator.pushNamed(context, '/focusContent',arguments: {
                          'url':this._articleData[index].link
                        });
                      },
                    ),
                    showMore(index),
                  ],
                );
              },
            ),
          ),
        )
        :!_searchRes
          ?Center(
            child: Container(
              child: Text(
                '换个关键字试试？',
                style: TextStyle(
                  fontSize: ScreenAdapter.size(36),
                  color: Colors.black54
                ),
              ),
            ),
          )
          :LoadingWidget()
    );
  }
}