import 'package:api_testing/features/home/models/usermod/address.dart';
import 'package:api_testing/features/home/models/usermod/company.dart';

class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final Company company;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'], // ✔️ correct
      email: json['email'],
      address: Address.fromJson(json['address']), // ✔️ nested
      phone: json['phone'],
      website: json['website'],
      company: Company.fromJson(json['company']), // ✔️ nested
    );
  }
}