class ContactModel {
  final String name;
  final String company;
  final String phone;
  final String email;
  final String website;
  final DateTime date;

  ContactModel({
    required this.name,
    required this.company,
    required this.phone,
    required this.email,
    required this.website,
    required this.date,
  });

  ContactModel copyWith({
    String? name,
    String? company,
    String? phone,
    String? email,
    String? website,
    DateTime? date,
  }) {
    return ContactModel(
      name: name ?? this.name,
      company: company ?? this.company,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "company": company,
    "phone": phone,
    "email": email,
    "website": website,
    "date": date.toIso8601String(), // ✅ correct way
  };

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      name: json['name']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
      date: _parseDate(json['date']),
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is DateTime) return value;

    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }
}
