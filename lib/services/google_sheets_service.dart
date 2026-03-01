import 'package:dio/dio.dart';
import '../models/contact_model.dart';
import '../core/constants/app_constants.dart';

class GoogleSheetsService {
  late final Dio _dio;
  final String _url = AppConstants.googleSheetsWebhookUrl;

  GoogleSheetsService() {
    _dio = Dio(
      BaseOptions(
        validateStatus: (status) {
          return status != null && status >= 200 && status < 400;
        },
      ),
    );
  }

  Future<bool> saveContact(ContactModel contact) async {
    try {
      final res = await _dio.post(_url, data: contact.toJson());

      return res.statusCode != null &&
          res.statusCode! >= 200 &&
          res.statusCode! < 400;
    } catch (e) {
      return false;
    }
  }

  Future<List<ContactModel>> getAllContacts() async {
    try {
      final res = await _dio.get(_url);

      if (res.statusCode == 200 && res.data is List) {
        return (res.data as List).map((e) => ContactModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}
