import 'package:app/const/url.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  Future<dynamic> getCustomerOrders(query) async {
    final _orderResponse = await Dio().get(
      baseUrl + "/order",
      queryParameters: query,
    );
    return _orderResponse.data;
  }
}
