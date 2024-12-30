import 'package:flutter/material.dart';

class ProductDetailsPage extends StatefulWidget {
  final String id;

  const ProductDetailsPage({super.key, required this.id});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('PRODUCT DETAIL: ${widget.id}'),
      ),
    );
  }
}
