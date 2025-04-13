import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final Function(Locale) onLanguageSelected;
  
  const LanguageSelector({
    Key? key,
    required this.onLanguageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      onSelected: onLanguageSelected,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        const PopupMenuItem<Locale>(
          value: Locale('en', ''),
          child: _LanguageItem(
            languageCode: 'en',
            languageName: 'English',
            flag: '🇺🇸',
          ),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('fr', ''),
          child: _LanguageItem(
            languageCode: 'fr',
            languageName: 'Français',
            flag: '🇫🇷',
          ),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('ar', ''),
          child: _LanguageItem(
            languageCode: 'ar',
            languageName: 'العربية',
            flag: '🇸🇦',
          ),
        ),
      ],
    );
  }
}

class _LanguageItem extends StatelessWidget {
  final String languageCode;
  final String languageName;
  final String flag;

  const _LanguageItem({
    Key? key,
    required this.languageCode,
    required this.languageName,
    required this.flag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(flag, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Text(languageName),
      ],
    );
  }
} 