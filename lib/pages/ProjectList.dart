import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../api/Api.dart';
import '../models/ProjectListModel.dart';
import '../utils/StringUtil.dart';
import '../widgets/ProjectListItem.dart';

class ProjectList extends StatefulWidget {
  final int cid;
  ProjectList(this.cid,{Key key}) : super(key: key);

  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> with AutomaticKeepAliveClientMixin{

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

  List <ProjectListItemModels> _projectListData=[];  //项目列表数据

  //获取项目列表数据
   _getProjectList() async{
    setState(() {
      this._flag=false;
    });
    var api=Api.projectList+"${this._page}/json?cid=${this._cid}";
    var response=await Dio().get(api);
    ProjectListModel projectList=ProjectListModel.fromJson(response.data);
    this._pageSize=projectList.data.size;
    if(projectList.data.datas.length<this._pageSize){
      this._hasMore=false;
      setState(() {
        this._projectListData.addAll(projectList.data.datas);
        this._page++;
        this._flag=true;
      });
    }else{
      setState(() {
        this._projectListData.addAll(projectList.data.datas);
        this._page++;
        this._flag=true;
      });
    }
  } 

  //判断商品列表底部进度条是否显示
  showMore(index){
    if(this._hasMore){
      return (index==this._projectListData.length-1)
        ?SpinKitCircle (
          color: Colors.teal,
          size: 30,
        )
        :Container(height: 0,);
    }else{
      return (index==this._projectListData.length-1)
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
    this._projectListData.clear();
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
    print(this._cid);
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
    return this._projectListData.length>0 
      ?RefreshIndicator(
      onRefresh: _refresh,
      child: Container(
       child: ListView.builder(
         controller: _scrollController,
         itemCount: this._projectListData.length,
         itemBuilder: (context,index){
           return Column(
             children: <Widget>[
               ProjectListItemWidget(
                title: StringUtil.strClean(this._projectListData[index].title),
                desc: StringUtil.strClean(this._projectListData[index].desc),
                time: this._projectListData[index].niceDate,
                author: this._projectListData[index].author,
                superChapterName: this._projectListData[index].superChapterName,
                chapterName: this._projectListData[index].chapterName,
                onTap: (){
                  Navigator.pushNamed(context, '/focusContent',arguments: {
                      'url':this._projectListData[index].link,
                      'title':this._projectListData[index].title
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