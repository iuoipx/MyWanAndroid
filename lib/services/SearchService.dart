import 'Storage.dart';
import 'dart:convert';

class SearchService{
  static setHistoryData(value) async{

    try{
      List searchListData=json.decode(await Storage.getString('searchList'));  //获取本地存储的数据('searchList')，没有数据跳出
      //print(searchListData);
      var hasData=searchListData.any((v){   //有数据时，判断本地存储是否有当前查询的数据
        return v==value;
      });
      if(!hasData){    //本地存储没有当前查询的数据时将本地存储数据和当前数据拼接传入
        searchListData.add(value);
        await Storage.setString('searchList',json.encode(searchListData));
      }
    }catch(e){  //没有本地存储的数据('searchList')时，直接将当前查询数据放入数组存入本地存储
      List tempList=new List();
      tempList.add(value);
      await Storage.setString('searchList',json.encode(tempList));
    }
  }

  static getHistoryData() async{
    try{
      List searchListData=json.decode(await Storage.getString('searchList'));
      //print(searchListData);
      return searchListData;
    }catch(e){ 
      return [];
    }
  }
  static clearHistoryData() async{
    await Storage.remove('searchList');
  }
  static removeHistoryData(value) async{
    List searchListData=json.decode(await Storage.getString('searchList'));
    searchListData.remove(value);
    await Storage.setString('searchList',json.encode(searchListData));
  }
}