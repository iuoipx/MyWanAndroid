import 'package:flutter/material.dart';
import 'package:mywanandroid/pages/ProjectList.dart';
import 'package:mywanandroid/utils/StringUtil.dart';
import 'package:mywanandroid/widgets/LoadingWidget.dart';
import '../models/ProjectModel.dart';
import 'package:dio/dio.dart';
import '../api/Api.dart';

class ProjectTab extends StatefulWidget {
  ProjectTab({Key key}) : super(key: key);

  _ProjectTabState createState() => _ProjectTabState();
}

class _ProjectTabState extends State<ProjectTab> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin{

  List <ProjectItemModel> _projectData=[];  //项目分类标题数据

  @override
  bool get wantKeepAlive => true;

  //获取项目分类标题
  _getProjectName() async{
    var api=Api.projectClassify;
    var response=await Dio().get(api);
    ProjectModel _projectList=ProjectModel.fromJson(response.data);
    setState(() {
      this._projectData=_projectList.data;
    });
  }


  TabController _tabController;
  @override
  void initState(){
    super.initState();
    this._getProjectName();
  }

  @override
  void dispose() {
    super.dispose();
    this._tabController.dispose();
  }

  PreferredSizeWidget _buildTabBar() {
    if (_projectData.length <= 0) {
      return null;
    }
    if (null == _tabController){
      _tabController = TabController(length: this._projectData.length, vsync: this);
    }
    return TabBar(
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.only(bottom: 2.0),
      indicatorWeight: 2,
      indicatorColor: Colors.black,
      controller: this._tabController,
      tabs: _buildTabs()
    );
  }

  List<Widget> _buildTabs() {
    return this._projectData?.map((value){
      return Tab(
        child: Text(
          StringUtil.strClean(value.name),
          style: TextStyle(color: Colors.black),
        ),
      );
    })?.toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return this._projectData.length>0
      ?Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,   //把状态栏字体颜色改为黑色
        title: _buildTabBar()
      ),
      body: TabBarView(
        controller: this._tabController,
        children: this._projectData.map((value){
          return ProjectList(value.id);
        }).toList()
      ),
    )
    :LoadingWidget();
  }
}