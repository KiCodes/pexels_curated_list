class PhotoModelResponse {
  final int? page;
  final int? perPage;
  final List<Photo>? photos;
  final int? totalResults;
  final String? nextPage;
  final String? prevPage;

  PhotoModelResponse({
    this.page,
    this.perPage,
    this.photos,
    this.totalResults,
    this.nextPage,
    this.prevPage,
  });

  factory PhotoModelResponse.fromJson(Map<String, dynamic> json) {
    var photosList = json['photos'] as List;
    List<Photo> photos =
        photosList.map((photo) => Photo.fromJson(photo)).toList();

    return PhotoModelResponse(
      page: json['page'],
      perPage: json['per_page'],
      photos: photos,
      totalResults: json['total_results'],
      nextPage: json['next_page'],
      prevPage: json['prev_page'],
    );
  }
}

class Photo {
  final int? id;
  final int? width;
  final int? height;
  final String? url;
  final String? photographer;
  final String? photographerUrl;
  final int? photographerId;
  final String? avgColor;
  final Src? src;
  final bool? liked;
  final String? alt;

  Photo({
    this.id,
    this.width,
    this.height,
    this.url,
    this.photographer,
    this.photographerUrl,
    this.photographerId,
    this.avgColor,
    this.src,
    this.liked,
    this.alt,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      width: json['width'],
      height: json['height'],
      url: json['url'],
      photographer: json['photographer'],
      photographerUrl: json['photographer_url'],
      photographerId: json['photographer_id'],
      avgColor: json['avg_color'],
      src: Src.fromJson(json['src']),
      liked: json['liked'],
      alt: json['alt'],
    );
  }
}

class Src {
  final String? original;
  final String? large2x;
  final String? large;
  final String? medium;
  final String? small;
  final String? portrait;
  final String? landscape;
  final String? tiny;

  Src({
    this.original,
    this.large2x,
    this.large,
    this.medium,
    this.small,
    this.portrait,
    this.landscape,
    this.tiny,
  });

  factory Src.fromJson(Map<String, dynamic> json) {
    return Src(
      original: json['original'],
      large2x: json['large2x'],
      large: json['large'],
      medium: json['medium'],
      small: json['small'],
      portrait: json['portrait'],
      landscape: json['landscape'],
      tiny: json['tiny'],
    );
  }
}
