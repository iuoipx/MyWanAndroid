import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mywanandroid/widgets/LoadingWidget.dart';
import '../api/Api.dart';
import '../models/SquareModel.dart';
import '../utils/StringUtil.dart';
import '../widgets/SquareListItem.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SquareTab extends StatefulWidget {
  SquareTab({Key key}) : super(key: key);

  _SquareTabState createState() => _SquareTabState();
}

class _SquareTabState extends State<SquareTab> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  //上拉分页
  ScrollController _scrollController=new ScrollController();
  int _page=0;  //页码
  //是否有数据
  bool _hasMore=true;
  //滑动到底请求数据完成之前不允许重复请求
  bool _flag=true;

  List <SquareItemModels> _squareListData=[];  //项目列表数据

  //获取广场列表数据
   _getSquareList() async{
    setState(() {
      this._flag=false;
    });
    var api=Api.squareList+"${this._page}/json";
    var response=await Dio().get(api);
    SquareModel squareList=SquareModel.fromJson(response.data);
    setState(() {
      this._squareListData.addAll(squareList.data.datas);
      this._page++;
      this._flag=true;
    });
    // if(squareList.data.datas.length<squareList.data.size){
    //   this._hasMore=false;
    //   setState(() {
    //     this._squareListData.addAll(squareList.data.datas);
    //     this._page++;
    //     this._flag=true;
    //   });
    // }else{
    //   setState(() {
    //     this._squareListData.addAll(squareList.data.datas);
    //     this._page++;
    //     this._flag=true;
    //   });
    // }
    if(squareList.data.datas.length<0){
      this._hasMore=false;
    }
  } 

  //判断商品列表底部进度条是否显示
  showMore(index){
    if(this._hasMore){
      return (index==this._squareListData.length-1)
        ?SpinKitCircle (
          color: Colors.teal,
          size: 30,
        )
        :Container(height: 0,);
    }else{
      return (index==this._squareListData.length-1)
        ?Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: Text('---已经到底了---',textAlign: TextAlign.center,),
        )
        :Container(height: 0,);
    }
  }


  //刷新数据
  _getRefreshSquareData() async{
    this._page=0;
    this._squareListData.clear();
    await _getSquareList();
  }

  Future<Null> _refresh() async {
    await _getRefreshSquareData();
    return;
  }

   @override
  void initState() { 
    super.initState();
    _getSquareList();
    this._scrollController.addListener((){
      //_scrollController.position.pixels;  //滚动条已经滚动高度
      //_scrollController.position.maxScrollExtent;   //页面高度
      if(_scrollController.position.pixels>_scrollController.position.maxScrollExtent-10){
        if(this._flag){
          setState(() {
            this._getSquareList();
          });
        }
      }  
    });
  }


  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('广场'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () =>  Scaffold.of(context).openDrawer(),
        ),
      ),
      body: this._squareListData.length>0
        ?RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: this._squareListData.length,
            itemBuilder: (context,index){
              return Column(
                children: <Widget>[
                  SquareListItemWidget(
                    title: StringUtil.strClean(this._squareListData[index].title),
                    time: this._squareListData[index].niceDate,
                    shareUser: this._squareListData[index].shareUser.length>10
                      ?this._squareListData[index].shareUser.substring(0,10)+'..'
                      :this._squareListData[index].shareUser,
                    fresh: this._squareListData[index].fresh,
                    onTap: (){
                      Navigator.pushNamed(context, '/focusContent',arguments: {
                          'url':this._squareListData[index].link,
                          'title':this._squareListData[index].title
                      });
                    },
                  ),
                  showMore(index)
                ],
              );
            },
          ),
        ),
      )
      :LoadingWidget(),
    );
  }
}