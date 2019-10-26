import 'package:flutter/material.dart';
import 'package:mywanandroid/fonts/IconF.dart';
import '../services/ScreenAdapter.dart';

class WeChatListItemWidget extends StatelessWidget {
  final String title;
  final String time;
  final String author;
  final String superChapterName;
  final String chapterName;
  final Object onTap;
  WeChatListItemWidget({this.title='',this.time='',this.author='',this.superChapterName='',this.chapterName='',this.onTap});
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Container(
      width: ScreenAdapter.width(750),
      padding: EdgeInsets.fromLTRB(ScreenAdapter.width(8), ScreenAdapter.width(8), ScreenAdapter.width(8), 0),
      color: Color.fromRGBO(233, 233, 233, 0.7),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
          child: InkWell(
            highlightColor: Color.fromRGBO(233, 233, 233, 0.7),
            borderRadius: BorderRadius.circular(6),
            splashColor: Colors.transparent,
            onTap: this.onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    '${this.title}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenAdapter.size(32)
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(ScreenAdapter.width(30), ScreenAdapter.width(20), ScreenAdapter.width(30), 0),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: ScreenAdapter.height(4)),
                        child: Icon(
                          IconF.time,
                          size: ScreenAdapter.size(30),
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${this.time}  @${this.author}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenAdapter.size(28)
                        ),
                      )
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(ScreenAdapter.width(30), ScreenAdapter.width(20), ScreenAdapter.width(30), 0),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(ScreenAdapter.width(2), 0, ScreenAdapter.width(2), 0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.red[400],
                          ),
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: Text(
                          '公众号',
                          style: TextStyle(
                            color: Colors.red[400],
                            fontSize: ScreenAdapter.size(24)
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        ' ${this.superChapterName}/${this.chapterName}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenAdapter.size(28)
                        ),
                      )
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(ScreenAdapter.width(30), ScreenAdapter.width(20), ScreenAdapter.width(30), ScreenAdapter.width(20)),
                ),
              ],
            ),
          )
        ) 
      ),
    );
  }
}