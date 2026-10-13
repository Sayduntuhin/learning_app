import 'package:flutter/material.dart';
import '../models/assessment_report_model.dart';

class AssessmentReportViewModel extends ChangeNotifier {
  final int overallScore = 64;
  final String levelCode = 'B1';

  final List<SkillScore> skills = const [
    SkillScore(
      name: 'Fluency',
      icon: '🗣️',
      percentage: 68,
      color: Color(0xFF6366F1), // Indigo
    ),
    SkillScore(
      name: 'Grammar',
      icon: '📝',
      percentage: 54,
      color: Color(0xFFEF4444), // Coral Red
    ),
    SkillScore(
      name: 'Vocabulary',
      icon: '📚',
      percentage: 72,
      color: Color(0xFF10B981), // Emerald
    ),
    SkillScore(
      name: 'Pronunciation',
      icon: '🎵',
      percentage: 61,
      color: Color(0xFFF59E0B), // Amber
    ),
  ];

  final List<SuggestionItem> suggestions = const [
    SuggestionItem(
      icon: Icons.track_changes_rounded,
      title: 'Practice daily sentences',
      description: 'Build grammar confidence with 5-min drills',
    ),
    SuggestionItem(
      icon: Icons.mic_rounded,
      title: 'Shadow native speakers',
      description: 'Mimic rhythm and pronunciation patterns',
    ),
    SuggestionItem(
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Speak without translating',
      description: 'Think directly in English to boost fluency',
    ),
  ];
}
