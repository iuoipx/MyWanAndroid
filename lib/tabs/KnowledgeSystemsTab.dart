import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../widgets/LoadingWidget.dart';
import '../services/ScreenAdapter.dart';
import '../api/Api.dart';
import '../models/SystemsModel.dart';

class KnowledgeSystemsTab extends StatefulWidget {
  KnowledgeSystemsTab({Key key}) : super(key: key);

  _KnowledgeSystemsTabState createState() => _KnowledgeSystemsTabState();
}

class _KnowledgeSystemsTabState extends State<KnowledgeSystemsTab> with AutomaticKeepAliveClientMixin{

  int _selectedIndex=0;
  List <SystemsItemModel> _leftCateData=[];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() { 
    super.initState();
    _getLeftCateData();
  }

  _getLeftCateData() async{
    //获取左侧数据
    var api=Api.treesList;
    var reponse=await Dio().get(api);
    var leftCateList=SystemsModel.fromJson(reponse.data);
    setState(() {
      this._leftCateData=leftCateList.data;
    });
  }

  Widget _leftCateWidget(leftWidth){
    if(this._leftCateData.length>0){
      return Container(
        width: leftWidth,
        height: double.infinity,
        child: ListView.builder(
          itemCount: this._leftCateData.length,
          itemBuilder: (context,index){
            return InkWell(
              child: Container(
                width: double.infinity,
                height: ScreenAdapter.height(100),
                color: this._selectedIndex==index?Colors.white:Color.fromRGBO(233, 233, 233, 0.9),
                child: Center(
                  child: Text(
                    "${this._leftCateData[index].name}",
                    style: TextStyle(
                      color: this._selectedIndex==index?Colors.black:Colors.black38,
                      fontSize: this._selectedIndex==index?ScreenAdapter.size(28):ScreenAdapter.size(24)
                    ),
                  ),
                ),
              ),
              onTap: (){
                setState(() {
                  this._selectedIndex=index;
                });
              },
            );
          },
        ),
      );
    }else{
      return Container(
        width: leftWidth,
        height: double.infinity,
      );
    }
  }

  Widget _rightCateWidget(rightItemWidth,rightItemHeight){
    if(this._leftCateData[_selectedIndex].children.length>0){
      return Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.all(10) ,
          height: double.infinity,
          color: Colors.white,
          child: ListView.builder(
            itemCount: this._leftCateData[_selectedIndex].children.length,
            itemBuilder: (context,index){
              return InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/system',arguments: {
                    'id':'${this._leftCateData[_selectedIndex].children[index].id}',
                    'name':'${this._leftCateData[_selectedIndex].children[index].name}'
                  });
                },
                child:Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: ScreenAdapter.height(80),
                        margin: EdgeInsets.fromLTRB(ScreenAdapter.width(20), ScreenAdapter.height(10), ScreenAdapter.width(20), ScreenAdapter.height(10)),
                        decoration: BoxDecoration(
                          color: Colors.blue[200],
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Center(
                          child: Text(
                            '${this._leftCateData[_selectedIndex].children[index].name}',
                            style: TextStyle(
                              fontSize: ScreenAdapter.size(28),
                              color: Colors.white
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              );
            },
          ),
        ),
      );
    }else{
      return Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.all(10) ,
          height: double.infinity,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenAdapter.init(context);
    //左侧宽度
    var leftWidth=ScreenAdapter.getScreenWidth()/4;
    //右侧每一项宽度
    var rightItemWidth=(ScreenAdapter.getScreenWidth()-leftWidth-40)/3;
    rightItemWidth=ScreenAdapter.width(rightItemWidth);
    //右侧每一项高度
    var rightItemHeight=rightItemWidth+ScreenAdapter.height(20);
    return Scaffold(
      appBar: AppBar(
        title: Text('体系'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () =>  Scaffold.of(context).openDrawer(),
        ),
      ),
      body: this._leftCateData.length>0
        ?Row(
          children: <Widget>[
            this._leftCateWidget(leftWidth),
            this._rightCateWidget(rightItemWidth, rightItemHeight)
          ],
        )
        :LoadingWidget(),
    );
  }
}