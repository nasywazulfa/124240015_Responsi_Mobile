import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartController extends GetxController {
  final Box _cartBox = Hive.box('cartBox');
  var cartItems = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  void loadCart() {
    final data = _cartBox.get('items', defaultValue: []);
    cartItems.value = (data as List)
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  bool isInCart(int id) => cartItems.any((p) => p.id == id);

  void addToCart(Product product) {
    if (!isInCart(product.id)) {
      cartItems.add(product);
      _saveCart();
      Get.snackbar(
        'Berhasil Ditambahkan',
        '${product.title} masuk ke keranjang.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600, 
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void removeFromCart(int id) {
    final productIndex = cartItems.indexWhere((p) => p.id == id);
    if (productIndex != -1) {
      final deletedProduct = cartItems[productIndex];
      cartItems.removeAt(productIndex);
      _saveCart();
      Get.snackbar(
        'Dihapus',
        '${deletedProduct.title} dihapus dari keranjang.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        icon: const Icon(Icons.delete_outline, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void clearCart() {
    cartItems.clear();
    _cartBox.delete('items');
  }

  void _saveCart() {
    final data = cartItems
        .map((p) => {
              'id': p.id,
              'title': p.title,
              'price': p.price,
              'description': p.description,
              'category': p.category,
              'image': p.image,
              'rating': {'rate': p.rating.rate, 'count': p.rating.count},
            })
        .toList();
    _cartBox.put('items', data);
  }

  int get totalItems => cartItems.length;
}