
class Poi {
  final int id;
  final String name;
  final String category;
  final String shortDescription;
  final String description;
  final String image;
  final String schedule;
  final double averagePrice;
  final String location;

  Poi({
    required this.id,
    required this.name,
    required this.category,
    required this.shortDescription,
    required this.description,
    required this.image,
    required this.schedule,
    required this.averagePrice,
    required this.location,
  });

  factory Poi.fromJson(Map<String, dynamic> json) {
    return Poi(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      shortDescription: json['short_description'],
      description: json['description'],
      image: json['image'],
      schedule: json['schedule'],
      averagePrice: (json['average_price'] as num).toDouble(),
      location: json['location'],
    );
  }
}