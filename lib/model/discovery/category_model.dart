class CategoryModel {
  int? id;
  String? name;
  String? description;
  String? bgPicture;
  String? bgColor;
  String? headerImage;
  int? defaultAuthorId;
  int? tagId;

  CategoryModel(
      {this.id,
        this.name,
        this.description,
        this.bgPicture,
        this.bgColor,
        this.headerImage,
        this.defaultAuthorId,
        this.tagId});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    bgPicture = json['bgPicture'];
    bgColor = json['bgColor'];
    headerImage = json['headerImage'];
    defaultAuthorId = json['defaultAuthorId'];
    tagId = json['tagId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['bgPicture'] = this.bgPicture;
    data['bgColor'] = this.bgColor;
    data['headerImage'] = this.headerImage;
    data['defaultAuthorId'] = this.defaultAuthorId;
    data['tagId'] = this.tagId;
    return data;
  }
}