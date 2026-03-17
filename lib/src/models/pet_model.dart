class PetModel {
  final String id;
  final String name;
  final String type;
  final String breed;
  final String age;
  final String gender;
  final String color;
  final String weight;
  final String? imagePath;

  PetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.gender,
    required this.color,
    required this.weight,
    this.imagePath,
  });

  factory PetModel.fromMap(String id, Map<String, dynamic> map) {
    return PetModel(
      id: id,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      breed: map['breed'] ?? '',
      age: map['age'] ?? '',
      gender: map['gender'] ?? '',
      color: map['color'] ?? '',
      weight: map['weight'] ?? '',
      imagePath: map['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'breed': breed,
      'age': age,
      'gender': gender,
      'color': color,
      'weight': weight,
      'imagePath': imagePath,
    };
  }
}
