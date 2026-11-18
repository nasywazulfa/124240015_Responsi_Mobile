import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final ApiService _apiService = ApiService();

  var products = <Product>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _apiService.fetchAllProducts();
      products.value = result;
    } catch (e) {
      errorMessage.value = 'Gagal memuat produk. Periksa koneksi internet.';
    } finally {
      isLoading.value = false;
    }
  }

  void clearProducts() {
    products.clear();
  }
}