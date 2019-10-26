import 'package:flutter/material.dart';
import '../tabs/BottomTab.dart';
import '../pages/FocusContent.dart';
import '../pages/SearchPage.dart';
import '../pages/SearchResult.dart';
import '../pages/SystemsList.dart';

final Map routes={
  '/':(context)=>BottomTab(),
  '/focusContent':(context,{arguments})=>FocusContent(arguments: arguments,),
  '/search':(context)=>SearchPage(),
  '/searchResult':(context,{arguments})=>SearchResult(arguments: arguments,),
  '/system':(context,{arguments})=>SystemsList(arguments:arguments),
};

// ignore: strong_mode_top_level_function_literal_block
var onGenerateRoute=(RouteSettings settings){
  final String name=settings.name;
  final Function pageContentBuilder=routes[name]; //把routes[name](即路由widget)传给pageContentBuilder
  if(pageContentBuilder!=null){
    if(settings.arguments!=null){
      final Route route=MaterialPageRoute(
        builder: (context)=>pageContentBuilder(context,arguments:settings.arguments)
      );
      return route;
    }else{
      final Route route=MaterialPageRoute(
        builder: (context)=>pageContentBuilder(context)
      );
      return route;
    }
  }
};