import 'package:flutter/material.dart';
import 'package:mywanandroid/fonts/IconF.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../services/ScreenAdapter.dart';
import '../api/Api.dart';
import 'package:dio/dio.dart';
import '../models/FocusModel.dart';
import '../widgets/LoadingWidget.dart';
import '../widgets/ArticleListItem.dart';
import '../models/ArticleModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/TopArticleModel.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key key}) : super(key: key);
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin{
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

  List <FocusItemModel> _foucsData=[];  //轮播图数据
  List <ArticleItemModels> _articleData=[];  //文章数据
  List <TopArticleItemModel> _topArticleData=[];  //置顶文章数据

  @override
  bool get wantKeepAlive => true;
  
  //获取轮播图数据
  _getFoucsData() async{  
    var api=Api.homeBanner;
    var result=await Dio().get(api);
    FocusModel focusList=FocusModel.fromJson(result.data);
    //print(focusList.result);
    setState(() {
      this._foucsData=focusList.data;
    });
  }

  //获取文章列表数据
  _getArticleData() async{
    //滑动到底时 -得到数据之前(即flag为false)时不允许重复请求
    setState(() {
      this._flag=false;
    });
    var api=Api.homeList+'${this._page}/json';
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

  //获取置顶文章数据
  _getTopArticleData() async{
    var topApi=Api.topArticle;
    var response=await Dio().get(topApi);
    TopArticleModel topArticleList=TopArticleModel.fromJson(response.data);
    setState(() {
      this._topArticleData=topArticleList.data;
    });
  }

  //刷新数据时重新获取数据
  _getRefreshArticleData() async{
    this._page=0;
    this._articleData.clear();
    _getArticleData();
    _getTopArticleData();
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
    await _getRefreshArticleData();
    await _getFoucsData();
    return;
  }

  //轮播图组件
  Widget _swiperWidget(){
    return Container(
      color: Color.fromRGBO(233, 233, 233, 0.7),
      child: Container(
        margin: EdgeInsets.fromLTRB(ScreenAdapter.width(8), ScreenAdapter.width(8), ScreenAdapter.width(8), 0),
        width: ScreenAdapter.width(750),
        decoration: BoxDecoration(
          color: Color.fromRGBO(233, 233, 233, 0.7),
          borderRadius: BorderRadius.circular(6),
        ),
        height: ScreenAdapter.getScreenWidth()/2,
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(233, 233, 233, 0.7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    this._foucsData[index].imagePath,
                    fit: BoxFit.fill,
                  ),
                );
              },
              itemCount: this._foucsData.length,
              autoplay: true,
              onTap: (index){
                Navigator.pushNamed(context, '/focusContent',arguments: {
                  'url':this._foucsData[index].url,
                  'title':this._foucsData[index].title
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  //文章列表组件
  Widget _articleList(context){
    return Container(
      child: ListView.builder(
        physics:NeverScrollableScrollPhysics(),
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
                shareUser: this._articleData[index].shareUser,
                fresh: this._articleData[index].fresh,
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
    );
  }

  Widget _topArticleList(){
    return Container(
      child: Column(
        children: this._topArticleData.map((value){
          return ArticleListItemWidget(
            title: value.title,
            time: value.niceDate,
            author: value.author,
            superChapterName: value.superChapterName,
            chapterName: value.chapterName,
            onTap: (){
              Navigator.pushNamed(context, '/focusContent',arguments: {
                'url':value.link,
                'title':value.title
              });
            },
            top: "置顶",
          );
        }).toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this._getFoucsData();
    this._getArticleData();
    this._getTopArticleData();
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
    //添加AutomaticKeepAliveClientMixin，并实现对应的方法bool get wantKeepAlive => true;
    //同时build方法实现父方法 super.build(context); 去掉警告
    super.build(context);   
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('博文'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () =>  Scaffold.of(context).openDrawer(),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/search');
            },
            icon: Icon(IconF.search),
          )
        ],
      ),
      body: this._foucsData.length>0&&this._articleData.length>0
        ?RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            controller: this._scrollController,
            child: Column(
              children: <Widget>[
                this._swiperWidget(),
                this._topArticleList(),
                this._articleList(context),
              ],
            ),
          ),
        )
        :LoadingWidget()
    );
  }
}
