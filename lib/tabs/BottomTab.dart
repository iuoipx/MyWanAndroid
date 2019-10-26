import 'package:flutter/material.dart';
import 'package:mywanandroid/fonts/IconF.dart';
import '../services/ScreenAdapter.dart';
import 'HomeTab.dart';
import 'KnowledgeSystemsTab.dart';
import 'SquareTab.dart';
import 'ProjectTab.dart';
import 'WeChatTab.dart';

class BottomTab extends StatefulWidget {
  final int index;
  BottomTab({Key key, this.index = 0}) : super(key: key);
  _BottomTabState createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  int _currentIndex=0;
  List <Widget> _pageList=[
    HomeTab(),
    ProjectTab(),
    SquareTab(),
    WeChatTab(),
    KnowledgeSystemsTab(),
  ];
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    this._currentIndex=widget.index;
    this._pageController=PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      body: PageView(
        children: this._pageList,
        controller: this._pageController,
        physics: NeverScrollableScrollPhysics(),
        // onPageChanged: (index){
        //   setState(() {
        //     this._currentIndex=index;
        //   });
        // },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            this._currentIndex=index;
            this._pageController.jumpToPage(index);
          });
        },
        currentIndex: this._currentIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.teal,
        items: [
          BottomNavigationBarItem(
            icon: Icon(IconF.blog),
            title: Text('博文')
          ),
          BottomNavigationBarItem(
            icon: Icon(IconF.project),
            title: Text('项目')
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            title: Text('广场')
          ),
          BottomNavigationBarItem(
            icon: Icon(IconF.wechat),
            title: Text('公众号')
          ),
          BottomNavigationBarItem(
            icon: Icon(IconF.tree),
            title: Text('体系')
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              margin: EdgeInsets.only(bottom: 0),
              accountName: Text("iuoip"),
              accountEmail: Text("4564687@qq.com"),
              currentAccountPicture: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(200)
                  ),
                  child: Image.asset('images/user.png')
                ),
                onTap: (){

                },
              ),
              decoration: BoxDecoration(
                color: Colors.teal
              ),
            ),
            Divider(height: 0,),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("设置"),
            ),
            Divider(height: 0,),
            ListTile(
              leading: Icon(Icons.help),
              title: Text("关于"),
            ),
            Divider(height: 0,),
            ListTile(
              leading:Icon(Icons.share),
              title: Text("分享"),
            ),
            Divider(height: 0,),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: ScreenAdapter.width(100),
        height: ScreenAdapter.height(100),
        margin: EdgeInsets.only(top: ScreenAdapter.height(20)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenAdapter.width(50)),
        ),
        child: FloatingActionButton(
          elevation: 4,
          child: Icon(
            Icons.add,
            size: ScreenAdapter.size(60),
          ),
          onPressed: () {
            setState(() {
              this._currentIndex = 2;
              this._pageController.jumpToPage(this._currentIndex);
            });
          },
          backgroundColor: this._currentIndex == 2 ? Colors.teal : Colors.yellow,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}