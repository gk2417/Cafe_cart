import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bottombar.dart';
import 'package:flutter_application_1/orderdata.dart';
import 'package:lottie/lottie.dart';

List<Map<String, dynamic>> orderList = [];
List<Map<String, dynamic>> item = [];

class ItemProfileScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  

  const ItemProfileScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          item["name"],
          style: const TextStyle(
              color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 253, 235, 229),
      ),
      backgroundColor: const Color.fromARGB(255, 253, 235, 229),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  item['image'],
                  width: double.maxFinite,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item['name']} ',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const Icon(Icons.star, color: Colors.orange),
                    Text(
                      item['rating'].toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 5),
                    const Text("(2640)"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Cake Size',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _sizeCard("Small", const Color.fromARGB(255, 230, 185, 169)),
                  _sizeCard("Medium", const Color.fromARGB(255, 184, 136, 119)),
                  _sizeCard("Large", const Color.fromARGB(255, 145, 107, 94)),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  item['description'],
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 20),

              // 🔽 Add to Cart Button
              MaterialButton(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  color: const Color.fromARGB(255, 75, 53, 45),
  height: 60,
  minWidth: 350,
  child: Text(
    'Add to cart    |   ${item['price']}',
    style: const TextStyle(
      fontSize: 15,
      color: Color.fromARGB(255, 228, 193, 181),
    ),
  ),
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) {
        bool _animationCompleted = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
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
                        'assets/add.json',
                        width: 150,
                        height: 150,
                        repeat: false,
                        onLoaded: (composition) {
                          Future.delayed(composition.duration, () {
                            setState(() {
                              _animationCompleted = true;
                            });
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${item['name']} is added!",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_animationCompleted)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            OrderData.addToOrder(item); // Add to orders
                            orderList.add(item); // Optional

                            // ✅ Navigate to BottomBar index 2 (Orders tab)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Bottombar(1),
                              ),
                            );
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
                        const SizedBox(height: 50), // Placeholder spacer
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
),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Helper method for Cake Size Cards
  Widget _sizeCard(String label, Color color) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: SizedBox(
        width: 100,
        height: 50,
        child: Center(
          child: Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
