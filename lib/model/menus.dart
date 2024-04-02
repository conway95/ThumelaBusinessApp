class Menus
{
  String? menuID;
  String? sellerUID;
  String? menuTitle;
  String? menuInfo;
  String? publishedDate;
  String? thumbnailUrl;
  String? status;

  Menus({
    this.menuID,
    this.sellerUID,
    this.menuTitle,
    this.menuInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.status
  });

  Menus.fromJson(Map<String, dynamic> json)
  {
    menuID = json["menuID"];
    sellerUID = json["uid"];
    menuTitle = json["menuTitle"];
    menuInfo = json["menuInfo"];
    publishedDate = json["publishedDate"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["menusID"] = menuID;
    data["uid"] = sellerUID;
    data["menuTitle"] = menuTitle;
    data["menuInfo"] = menuInfo;
    data["publishedDate"] = publishedDate;
    data["thumbnailUrl"] = thumbnailUrl;
    data["status"] = status;

    return data;
  }

}