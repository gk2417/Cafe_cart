// lib/order_data.dart
class OrderData {
  static final List<Map<String, dynamic>> orderList = [];

  static void addToOrder(Map<String, dynamic> item) {
    orderList.add(item);
  }

  static List<Map<String, dynamic>> getOrders() {
    return orderList;
  }

  static void removeFromOrder(int index) {
  if (index >= 0 && index < orderList.length) {
    orderList.removeAt(index);
  }

  
}

}
