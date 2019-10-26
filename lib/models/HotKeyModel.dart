class HotKeyModel {
  List<HotKeyItemModel> data;
  int errorCode;
  String errorMsg;

  HotKeyModel({this.data, this.errorCode, this.errorMsg});

  HotKeyModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<HotKeyItemModel>();
      json['data'].forEach((v) {
        data.add(new HotKeyItemModel.fromJson(v));
      });
    }
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class HotKeyItemModel {
  int id;
  String link;
  String name;
  int order;
  int visible;

  HotKeyItemModel({this.id, this.link, this.name, this.order, this.visible});

  HotKeyItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
    name = json['name'];
    order = json['order'];
    visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['link'] = this.link;
    data['name'] = this.name;
    data['order'] = this.order;
    data['visible'] = this.visible;
    return data;
  }
}