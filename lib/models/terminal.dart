// terminal.dart

import 'dart:convert';

class Terminal {
  final String id;
  final String title;
  final String address;
  final String coordinates;

  Terminal({
    required this.id,
    required this.title,
    required this.address,
    required this.coordinates,
  });

  factory Terminal.fromJson(Map<String, dynamic> json) {
    return Terminal(
      id: json['id'],
      title: json['title'],
      address: json['address'],
      coordinates: json['coordinates'],
    );
  }
}

List<Terminal> parseTerminals(String jsonString) {
  final List<Terminal> terminals = [];
  final jsonData = json.decode(jsonString);

  final branches = jsonData['branches'];
  if (branches != null && branches.isNotEmpty) {
    final division = branches[0]['division'];
    if (division != null && division.isNotEmpty) {
      for (var terminalData in division) {
        final id = terminalData['id'];
        final title = terminalData['title'];
        final address = terminalData['address'];
        final coordinates = terminalData['coordinates'];

        if (id != null && title != null && address != null && coordinates != null) {
          terminals.add(
            Terminal(
              id: id,
              title: title,
              address: address,
              coordinates: coordinates,
            ),
          );
        }
      }
    }
  }

  return terminals;
}
