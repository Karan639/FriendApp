import 'package:equatable/equatable.dart';

class Query extends Equatable {
  final int id;
  final String subject;
  final String description;
  final String status;
  final Customer customer;

  const Query({
    required this.id,
    required this.subject,
    required this.description,
    required this.status,
    required this.customer,
  });

  factory Query.fromJson(Map<String, dynamic> json) {
    return Query(
      id: json['id'],
      subject: json['subject'],
      description: json['description'],
      status: json['status'],
      customer: Customer.fromJson(json['customer']),
    );
  }

  @override
  List<Object> get props => [id, subject, description, status, customer];
}

class Customer extends Equatable {
  final int id;

  const Customer({required this.id});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(id: json['id']);
  }

  @override
  List<Object> get props => [id];
}