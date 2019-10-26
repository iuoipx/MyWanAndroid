import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/ScreenAdapter.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Center(
      child: Container(
        width: ScreenAdapter.width(240),
        height: ScreenAdapter.height(240),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SpinKitCircle (
              color: Colors.teal,
              size: 40.0,
            ),
            Container(
              height: 8,
            ),
            Text(
              '正在加载中...',
              style: TextStyle(
                fontSize: 14
              ),
            )
          ],
        ),
      ),
    );
  }
}