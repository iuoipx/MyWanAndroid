import 'package:flutter/material.dart';
import 'package:mywanandroid/pages/WeChatList.dart';
import 'package:mywanandroid/utils/StringUtil.dart';
import 'package:mywanandroid/widgets/LoadingWidget.dart';
import '../api/Api.dart';
import 'package:dio/dio.dart';
import '../models/ProjectModel.dart';

class WeChatTab extends StatefulWidget {
  WeChatTab({Key key}) : super(key: key);

  _WeChatTabState createState() => _WeChatTabState();
}

class _WeChatTabState extends State<WeChatTab> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  
  List <ProjectItemModel> _weChatData=[];  //公众号分类标题数据

  @override
  bool get wantKeepAlive => true;

  //获取公众号分类标题
  _getWeChatName() async{
    var api=Api.mpWeChatNames;
    var response=await Dio().get(api);
    ProjectModel _weChatList=ProjectModel.fromJson(response.data);
    setState(() {
      this._weChatData=_weChatList.data;
    });
  }

  TabController _tabController;
  @override
  void initState(){
    super.initState();
    this._getWeChatName();
  }

  @override
  void dispose() {
    super.dispose();
    this._tabController.dispose();
  }

  PreferredSizeWidget _buildTabBar() {
    if (_weChatData.length <= 0) {
      return null;
    }
    if (null == _tabController){
      _tabController = TabController(length: this._weChatData.length, vsync: this);
    }
    return TabBar(
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.only(bottom: 2.0),
      indicatorWeight: 2,
      indicatorColor: Colors.white,
      controller: this._tabController,
      tabs: _buildTabs()
    );
  }

  List<Widget> _buildTabs() {
    return this._weChatData?.map((value){
      return Tab(
        child: Text(
          StringUtil.strClean(value.name),
        ),
      );
    })?.toList();
  }

  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return this._weChatData.length>0
      ?Scaffold(
      appBar: AppBar(
        title: Text('公众号'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () =>  Scaffold.of(context).openDrawer(),
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(IconF.search),
        //     onPressed: (){

        //     },
        //   )
        // ],
        bottom: _buildTabBar(),
      ),
      body: TabBarView(
        controller: this._tabController,
        children: this._weChatData.map((value){
          return WeChatList(value.id);
        }).toList()
      ),
    )
    :LoadingWidget();
  }
}
