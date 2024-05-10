import 'dart:convert';

class LocalizationService {
  Map<String, dynamic>? _localizedValues;

  Future<void> loadJson(String jsonStr) async {
    _localizedValues = json.decode(jsonStr);
  }

  String? translate(String key) {
    return _localizedValues?[key];
  }
}