import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdapter{
  static init(context){
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
  }
  static width(double value){
    return ScreenUtil.getInstance().setWidth(value);
  }
  static height(double value){
    return ScreenUtil.getInstance().setHeight(value);
  }
  static getScreenWidth(){
    return ScreenUtil.screenWidthDp; 
  }
  static getScreenHeight(){
    return ScreenUtil.screenHeightDp;
  }
  static size(double value){
    return ScreenUtil.getInstance().setSp(value);
  }
}