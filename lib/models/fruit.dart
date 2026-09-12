import 'package:flutter/material.dart';

class CareTask {
  final String name;
  final String recurring;

  CareTask({required this.name, required this.recurring});

  Map<String, dynamic> toJson() => {'name': name, 'recurring': recurring};

  factory CareTask.fromJson(Map<String, dynamic> json) => CareTask(
        name: json['name'] as String,
        recurring: json['recurring'] as String,
      );
}

class Fruit {
  final String id;
  final String name;
  final String description;
  final String type;
  final String toxicity;
  final String watering;
  final String climate;
  final IconData icon;
  final Color color;
  final String? imagePath; // path to the photo saved on-device, if one was taken
  final List<CareTask> tasks;

  Fruit({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.toxicity,
    required this.watering,
    required this.climate,
    required this.icon,
    required this.color,
    this.imagePath,
    List<CareTask>? tasks,
  }) : tasks = tasks ?? [];

  String get status => tasks.isEmpty ? 'No any task' : tasks.first.name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'type': type,
        'toxicity': toxicity,
        'watering': watering,
        'climate': climate,
        'iconCodePoint': icon.codePoint,
        'colorValue': color.value,
        'imagePath': imagePath,
        'tasks': tasks.map((t) => t.toJson()).toList(),
      };

  factory Fruit.fromJson(Map<String, dynamic> json) => Fruit(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        type: json['type'] as String,
        toxicity: json['toxicity'] as String,
        watering: json['watering'] as String,
        climate: json['climate'] as String,
        icon: IconData(json['iconCodePoint'] as int, fontFamily: 'MaterialIcons'),
        color: Color(json['colorValue'] as int),
        imagePath: json['imagePath'] as String?,
        tasks: (json['tasks'] as List<dynamic>? ?? [])
            .map((t) => CareTask.fromJson(t as Map<String, dynamic>))
            .toList(),
      );
}

class NurseryPlant {
  final String name;
  final String category; // Indoor / Outdoor / Indoor/Outdoor
  final double price;
  final IconData icon;
  final Color color;

  NurseryPlant({
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category,
        'price': price,
        'iconCodePoint': icon.codePoint,
        'colorValue': color.value,
      };

  factory NurseryPlant.fromJson(Map<String, dynamic> json) => NurseryPlant(
        name: json['name'] as String,
        category: json['category'] as String,
        price: (json['price'] as num).toDouble(),
        icon: IconData(json['iconCodePoint'] as int, fontFamily: 'MaterialIcons'),
        color: Color(json['colorValue'] as int),
      );
}