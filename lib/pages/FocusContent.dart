import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import '../services/ScreenAdapter.dart';
import 'package:share/share.dart';

class FocusContent extends StatefulWidget {
  final Map arguments;
  FocusContent({Key key,this.arguments}) : super(key: key);

  _FocusContentState createState() => _FocusContentState();
}

class _FocusContentState extends State<FocusContent>{

  Map _foucsData={};
  bool isLoading=true;
  String _title;
  Timer _timer;
  int progress = 0;  //进度条

  Widget _progressBar() {
    print(progress);
    return SizedBox(
      height: isLoading ? ScreenAdapter.height(4) : 0,
      child: LinearProgressIndicator(
        value: isLoading ? progress / 100 : 1,
        backgroundColor: Color(0xfff3f3f3),
        valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
      ),
    );
  }

   /// 模拟异步加载
  Future _simulateProgress() async {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(milliseconds: 50), (time) {
        progress++;
        if (progress > 98) {
          _timer.cancel();
          _timer = null;
          return;
        } else {
          setState(() {});
        }
      });
    }
  }

  @override
  void initState(){
    super.initState();
    this._foucsData=widget.arguments;
    //对http进行处理  "http"=>"https"
    this._foucsData['url']=this._foucsData['url'].substring(0, 5)=="https"
      ?this._foucsData['url']
      :this._foucsData['url'].replaceAll("http", "https");
    this._title=this._foucsData['title'];  
    _simulateProgress();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Container(
       child: Scaffold(
         appBar: AppBar(
           title: Text(
             '${this._title}',
             style: TextStyle(
               fontSize: ScreenAdapter.size(36)
             ),
           ),
           centerTitle: true,
           actions: <Widget>[
             IconButton(
               icon: Icon(Icons.share),
               onPressed: (){
                 Share.share( '${this._title}\n ${this._foucsData['url']}');
               },
             )
           ],
           bottom: PreferredSize(
            child: _progressBar(),
            preferredSize: Size.fromHeight(ScreenAdapter.height(4.0)),
          ),
         ),
         body: WebView(
          initialUrl: this._foucsData['url'],
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            setState(() {
              this.isLoading=true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              this.isLoading=false;
            });
          },
         )
       ),
    );
  }
}