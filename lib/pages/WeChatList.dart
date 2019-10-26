import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mywanandroid/api/Api.dart';
import 'package:mywanandroid/models/WeChatModel.dart';
import 'package:mywanandroid/utils/StringUtil.dart';
import 'package:mywanandroid/widgets/WeChatListItem.dart';

class WeChatList extends StatefulWidget {
  final int cid;
  WeChatList(this.cid,{Key key}) : super(key: key);

  _WeChatListState createState() => _WeChatListState();
}

class _WeChatListState extends State<WeChatList> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  //上拉分页
  ScrollController _scrollController=new ScrollController();
  int _page=1;  //页码
  int _pageSize;  //每一页返回数据条数
  //是否有数据
  bool _hasMore=true;
  //滑动到底请求数据完成之前不允许重复请求
  bool _flag=true;
  int _cid;

  List <WeChatItemModels> _weChatListData=[];  //项目列表数据

  //获取项目列表数据
   _getProjectList() async{
    setState(() {
      this._flag=false;
    });
    var api=Api.mpWeChatList+"${this._cid}"+"/${this._page}/json";
    var response=await Dio().get(api);
    WeChatModel weChatList=WeChatModel.fromJson(response.data);
    this._pageSize=weChatList.data.size;
    if(weChatList.data.datas.length<this._pageSize){
      this._hasMore=false;
      setState(() {
        this._weChatListData.addAll(weChatList.data.datas);
        this._page++;
        this._flag=true;
      });
    }else{
      setState(() {
        this._weChatListData.addAll(weChatList.data.datas);
        this._page++;
        this._flag=true;
      });
    }
  } 

  //判断商品列表底部进度条是否显示
  showMore(index){
    if(this._hasMore){
      return (index==this._weChatListData.length-1)
        ?SpinKitCircle (
          color: Colors.teal,
          size: 30,
        )
        :Container(height: 0,);
    }else{
      return (index==this._weChatListData.length-1)
        ?Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: Text('---已经到底了---',textAlign: TextAlign.center,),
        )
        :Container(height: 0,);
    }
  }


  //刷新数据
  _getRefreshProjectData() async{
    this._page=1;
    this._weChatListData.clear();
    await _getProjectList();
  }

  Future<Null> _refresh() async {
    await _getRefreshProjectData();
    return;
  }

   @override
  void initState() { 
    super.initState();
    this._cid=widget.cid;
    _getProjectList();
    this._scrollController.addListener((){
      //_scrollController.position.pixels;  //滚动条已经滚动高度
      //_scrollController.position.maxScrollExtent;   //页面高度
      if(_scrollController.position.pixels>_scrollController.position.maxScrollExtent-10){
        if(this._flag&&this._hasMore){
          setState(() {
            this._getProjectList();
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
    return this._weChatListData.length>0 
      ?RefreshIndicator(
      onRefresh: _refresh,
      child: Container(
       child: ListView.builder(
         controller: _scrollController,
         itemCount: this._weChatListData.length,
         itemBuilder: (context,index){
           return Column(
             children: <Widget>[
               WeChatListItemWidget(
                title: StringUtil.strClean(this._weChatListData[index].title),
                time: this._weChatListData[index].niceDate,
                author: this._weChatListData[index].author,
                superChapterName: this._weChatListData[index].superChapterName,
                chapterName: this._weChatListData[index].chapterName,
                onTap: (){
                  Navigator.pushNamed(context, '/focusContent',arguments: {
                      'url':this._weChatListData[index].link,
                      'title':this._weChatListData[index].title
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
    :SpinKitChasingDots(
      color: Colors.teal,
    );
  }
}