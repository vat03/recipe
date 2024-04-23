class Recipe {
  String title;
  String photo;
  double calories;
  String time;
  String description;

  List<dynamic>? ingridients;
  String? tutorial;
  List<Review>? reviews;

  Recipe(
      {required this.title,
      required this.photo,
      required this.calories,
      required this.time,
      required this.description,
      this.ingridients,
      this.tutorial,
      this.reviews});

  // to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'photo': photo,
      'calories': calories,
      'time': time,
      'description': description,
      'ingridients': ingridients,
      'tutorial': tutorial,
      'reviews': reviews,
    };
  }

  // to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'photo': photo,
      'calories': calories,
      'time': time,
      'description': description,
      'ingridients': ingridients,
      'tutorial': tutorial,
      'reviews': reviews,
    };
  }

  factory Recipe.fromJson(Map json) {
    return Recipe(
      title: json['title'],
      photo: json['photo'],
      calories: json['calories'],
      time: json['time'],
      tutorial: json['tutorial'],
      description: json['description'],
    );
  }
}

class TutorialStep {
  String step;
  String? description;
  TutorialStep({required this.step, this.description});

  Map<String, dynamic> toMap() {
    return {
      'step': step,
      'description': description ?? '',
    };
  }

  factory TutorialStep.fromJson(Map json) => TutorialStep(
        step: json['step'],
        description: json['description'],
      );

  static List<TutorialStep> toList(List<Map<String, dynamic>> json) {
    return List.from(json)
        .map(
            (e) => TutorialStep(step: e['step'], description: e['description']))
        .toList();
  }
}

class Review {
  String username;
  String review;
  Review({required this.username, required this.review});

  factory Review.fromJson(Map json) => Review(
        review: json['review'],
        username: json['username'],
      );

  Map<String, Object> toMap() {
    return {
      'username': username,
      'review': review,
    };
  }

  static List<Review> toList(List<Map<String, dynamic>> json) {
    return List.from(json)
        .map((e) => Review(username: e['username'], review: e['review']))
        .toList();
  }
}

class Ingridient {
  String name;
  String size;

  Ingridient({required this.name, required this.size});
  factory Ingridient.fromJson(Map<String, dynamic> json) => Ingridient(
        name: json['name'],
        size: json['size'],
      );

  Map<String, Object> toMap() {
    return {
      'name': name,
      'size': size,
    };
  }

  static List<Ingridient> toList(List<Map<String, Object>> json) {
    return List.from(json)
        .map((e) => Ingridient(name: e['name'], size: e['size']))
        .toList();
  }
}
