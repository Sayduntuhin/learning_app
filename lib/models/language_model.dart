import '../widgets/flag_icon_widget.dart';

class LanguageOption {
  final String name;
  final CountryFlag flag;
  final String code;

  const LanguageOption({
    required this.name,
    required this.flag,
    required this.code,
  });

  static const List<LanguageOption> supportedLanguages = [
    LanguageOption(name: 'English', flag: CountryFlag.uk, code: 'EN'),
    LanguageOption(name: 'German', flag: CountryFlag.germany, code: 'DE'),
    LanguageOption(name: 'Russia', flag: CountryFlag.russia, code: 'RU'),
    LanguageOption(name: 'Spanish', flag: CountryFlag.spain, code: 'ES'),
    LanguageOption(name: 'Portugal', flag: CountryFlag.portugal, code: 'PT'),
  ];

  static CountryFlag flagForLanguage(String lang) {
    switch (lang.toLowerCase()) {
      case 'german':
        return CountryFlag.germany;
      case 'russia':
        return CountryFlag.russia;
      case 'spanish':
        return CountryFlag.spain;
      case 'portugal':
        return CountryFlag.portugal;
      case 'english':
      default:
        return CountryFlag.uk;
    }
  }

  static String codeForLanguage(String lang) {
    switch (lang.toLowerCase()) {
      case 'german':
        return 'DE';
      case 'russia':
        return 'RU';
      case 'spanish':
        return 'ES';
      case 'portugal':
        return 'PT';
      case 'english':
      default:
        return 'EN';
    }
  }
}
