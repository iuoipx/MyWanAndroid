import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mywanandroid/widgets/ArticleListItem.dart';
import '../widgets/LoadingWidget.dart';
import '../models/ArticleModel.dart';
import '../services/ScreenAdapter.dart';
import '../api/Api.dart';


class SystemsList extends StatefulWidget {
  final Map arguments;
  SystemsList({Key key,this.arguments}) : super(key: key);
  _SystemsListState createState() => _SystemsListState();
}

class _SystemsListState extends State<SystemsList> {

  //上拉分页
  ScrollController _scrollController=new ScrollController();
  //滑动到底请求数据完成之前不允许重复请求
  bool _flag=true;
  //分页
  int _page=0;
  //每一页返回数据条数
  int _pageSize;
  //是否有数据
  bool _hasMore=true;

  var _id;
  var _title;

  List <ArticleItemModels> _articleData=[];  //文章数据

  //获取文章列表数据
  _getArticleData() async{
    setState(() {
      this._flag=false;
    });
    var api=Api.treesDetailList+'${this._page}/json?cid=${this._id}';
    var result=await Dio().get(api);
    ArticleModel articleList=ArticleModel.fromJson(result.data);
    // setState(() {
    //   this._articleData=articleList.data.datas;
    // });
    //print(this._articleData.length);  //20
    
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

  //刷新数据时重新获取数据
  _getRefreshArticleData() async{
    this._page=0;
    this._articleData.clear();
    _getArticleData();
  }

  Future<Null> _refresh() async {
    await _getRefreshArticleData();
    return;
  }
  
  @override
  void initState() {
    super.initState();
    this._id=widget.arguments['id'];
    this._title=widget.arguments['name'];
    _getArticleData();
    this._scrollController.addListener((){
      //_scrollController.position.pixels;  //滚动条已经滚动高度
      //_scrollController.position.maxScrollExtent;   //页面高度
      if(_scrollController.position.pixels>_scrollController.position.maxScrollExtent-10){
        if(this._flag&&this._hasMore){
          setState(() {
            this._getArticleData();
          });
        }
      }  
    });
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${this._title}',
          style: TextStyle(
            fontSize: ScreenAdapter.size(32)
          ),
        ),
        centerTitle: true,
      ),
      body: this._articleData.length>0
        ?RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: this._articleData.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true, //使用子控件的总长度来设置ListView的长度（这里的长度为高度）
            itemBuilder: (context,index){
              return Column(
                children: <Widget>[
                  ArticleListItemWidget(
                    title: this._articleData[index].title,
                    time: this._articleData[index].niceDate,
                    author: this._articleData[index].author,
                    superChapterName: this._articleData[index].superChapterName,
                    chapterName: this._articleData[index].chapterName,
                    onTap: (){
                      Navigator.pushNamed(context, '/focusContent',arguments: {
                        'url':this._articleData[index].link,
                        'title':this._articleData[index].title
                      });
                    },
                  ),
                  showMore(index),
                ],
              );
            },
          ),
        )
        :LoadingWidget(),
    );
  }
}