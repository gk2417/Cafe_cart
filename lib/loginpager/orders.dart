import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bottombar.dart';
import 'package:flutter_application_1/orderdata.dart';
import 'package:lottie/lottie.dart';

class Orders extends StatefulWidget {
  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Map<String, dynamic>> orderItem = [];

  @override
  void initState() {
    super.initState();
    orderItem = OrderData.getOrders();
  }

  void removeItem(int index) {
    setState(() {
      OrderData.removeFromOrder(index);
    });
  }

  double getTotalPrice() {
    return orderItem.fold(0.0, (sum, item) {
      final raw = item['price'].toString().replaceAll('\$', '');
      final price = double.tryParse(raw) ?? 0.0;
      return sum + price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(



      
      backgroundColor: const Color.fromARGB(255, 253, 235, 229),
      appBar: AppBar(
        title: const Text(
          "My Orders ... ",
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 253, 235, 229),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: orderItem.length,
              itemBuilder: (context, index) {
                final item = orderItem[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: const Color.fromARGB(255, 238, 193, 176),
                    elevation: 10,
                    child: SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                item['image'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text("\$${item['price']}",
                                    style: const TextStyle(color: Colors.brown)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () => removeItem(index),
                              child: const Icon(Icons.cancel_outlined,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// Total price and "OK" Button section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: MaterialButton(
                onPressed: () {
                  final totalPrice = getTotalPrice();

                  if (totalPrice <= 0) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("No Items"),
                        content: const Text("You haven't added any items to the cart."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      bool animationDone = false;

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: const EdgeInsets.all(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(180, 255, 225, 214),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Lottie.asset(
                                      'assets/addcart.json',
                                      width: 150,
                                      height: 150,
                                      repeat: false,
                                      onLoaded: (composition) {
                                        Future.delayed(composition.duration, () {
                                          setState(() {
                                            animationDone = true;
                                          });
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Total Price: \$${totalPrice.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.brown,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    if (animationDone)
                                      ElevatedButton(
  onPressed: () {
    Navigator.pop(context);
    if (orderItem.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Bottombar(2), // 👈 Go to index 2 (Orders)
        ),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.brown,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: const Text("OK", style: TextStyle(color: Colors.white)),
)

                                    else
                                      const SizedBox(height: 50),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.brown,
                child: Text(
                  "Total: \$${getTotalPrice().toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
