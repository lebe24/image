class ImageData {
  final List<Datum> data;
  final bool success;
  final int status;

  ImageData({
    required this.data,
    required this.success,
    required this.status,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      success: json['success'],
      status: json['status'],
    );
  }
}

class Datum {
  final String id;
  final String title;
  final String? description;
  final String cover;
  final List<Image>? images;

  Datum({
    required this.id,
    required this.title,
    this.description,
    required this.cover,
    this.images,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json['id'] ?? "",
      title: json['title'] ?? '',
      description: json['description'] ?? "",
      cover: json['cover'] ?? "",
      images: json["images"] != null
        ? List<Image>.from(json["images"].map((x) => Image.fromJson(x)))
        : [], // Use an empty list if "images" is null

    );
  }
}


class Image {
  final String id;
  final String? title;
  final String? description;
  final String link;

  Image({
    required this.id,
    this.title,
    this.description,
    required this.link,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'] ?? "",
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      link: json['link'] ?? " ",
    );
  }
}

