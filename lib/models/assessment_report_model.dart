import 'package:flutter/material.dart';

class SkillScore {
  final String name;
  final String icon;
  final int percentage;
  final Color color;

  const SkillScore({
    required this.name,
    required this.icon,
    required this.percentage,
    required this.color,
  });
}

class SuggestionItem {
  final IconData icon;
  final String title;
  final String description;

  const SuggestionItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
