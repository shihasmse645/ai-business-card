import 'package:flutter/material.dart';
import '../../models/contact_model.dart';
import '../../services/google_sheets_service.dart';

class DashboardProvider with ChangeNotifier {
  List<ContactModel> contacts = [];
  String searchQuery = '';
  bool isLoading = false;

  final GoogleSheetsService _sheetsService = GoogleSheetsService();

  Future<void> loadContacts() async {
    isLoading = true;
    notifyListeners();

    contacts = await _sheetsService.getAllContacts();
    contacts.sort((a, b) => b.date.compareTo(a.date));

    isLoading = false;
    notifyListeners();
  }

  void updateSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  List<ContactModel> get filteredContacts {
    if (searchQuery.isEmpty) return contacts;
    return contacts
        .where(
          (c) =>
              c.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              c.company.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }
}
