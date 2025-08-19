import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bottombar.dart';
import 'package:flutter_application_1/orderdata.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<Map<String, dynamic>> orderItem = [];

  final Razorpay _razorpay = Razorpay();
  final TextEditingController _couponController = TextEditingController();

  bool isCouponApplied = false;
  double discount = 0.0;

  @override
  void initState() {
    super.initState();
    orderItem = OrderData.getOrders();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
      final transactionId = response.paymentId ?? "N/A";

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessScreen(
            name: orderItem.isNotEmpty ? orderItem[0]['name'] : "Unknown",
            originalPrice: getOriginalPrice(),
            discount: discount,
            transactionId: transactionId,
          ),
        ),
      );
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment Failed')),
      );
    });

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('External Wallet Selected')),
      );
    });
  }

  double getOriginalPrice() {
    return orderItem.fold(0.0, (sum, item) {
      final raw = item['price'].toString().replaceAll('\$', '');
      final price = double.tryParse(raw) ?? 0.0;
      return sum + price;
    });
  }

  double getDiscountedPrice() {
    final total = getOriginalPrice();
    return total - discount;
  }

  void _applyCoupon() {
    final code = _couponController.text.trim();
    final total = getOriginalPrice();

    if (code.toUpperCase() == "GOKUL10" && !isCouponApplied) {
      setState(() {
        discount = total * 0.10;
        isCouponApplied = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Coupon Applied: 10% Off")),
      );
    } else if (isCouponApplied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Coupon Already Applied")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Coupon Code")),
      );
    }
  }

  void _openCheckout(num amount) {
    var options = {
      "key": "rzp_test_2WWjyB29TPpIza",
      "amount": (amount * 100).toInt(),
      "name": "StratUp Project",
      "description": "Cart Total Payment",
      "prefill": {
        "contact": "7904892889",
        "email": "gokulkumargk@gmail.com",
      },
      "external": {
        "wallets": ["paytm"],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Payment Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    double originalPrice = getOriginalPrice();
    double finalPrice = getDiscountedPrice();

    return Scaffold(
      appBar: AppBar(
        title: Text(
    "Pay Now.",
    textAlign: TextAlign.center,
    style: GoogleFonts.poppins(
      fontSize: 16,
      color: Color.fromARGB(255, 0, 0, 0),
      height: 1.5,
    ),
  ),
        
        actions: [
          Padding(padding: const EdgeInsets.all(20),
          child: Icon(Icons.payments_outlined,size: 30,color: const Color.fromARGB(255, 255, 255, 255),)
          ),  
        ],
        
        backgroundColor: Colors.brown,
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
                                Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text("\$${item['price']}", style: const TextStyle(color: Colors.brown)),
                              ],
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

          // Apply Coupon Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              color: const Color.fromARGB(255, 238, 193, 176),
              child: ListTile(
                title: const Text("Apply Coupon"),
                trailing: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Enter Coupon Code"),
                          content: TextField(
                            controller: _couponController,
                            decoration: const InputDecoration(
                              hintText: "Enter code",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _applyCoupon();
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                              child: const Text("Apply", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  child: const Text("Apply", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),

          // Pay Now Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: MaterialButton(
                onPressed: () {
                  if (finalPrice <= 0) {
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

                  _openCheckout(finalPrice);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.brown,
                child: Text(
                  "Pay Now: \$${finalPrice.toStringAsFixed(2)}",
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
      backgroundColor: const Color.fromARGB(255, 253, 235, 229),
    );
  }
}



class PaymentSuccessScreen extends StatelessWidget {
  final String name;
  final double originalPrice;
  final double discount;
  final String transactionId;

  const PaymentSuccessScreen({
    super.key,
    required this.name,
    required this.originalPrice,
    required this.discount,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    final finalPrice = originalPrice - discount;

    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.brown,
  title:  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          'Payment Successful',
          textStyle: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          speed: const Duration(milliseconds: 100),
        ),
      ],
      isRepeatingAnimation: false,
      totalRepeatCount: 1,
    ),
    const SizedBox(height: 4),
    AnimatedTextKit(
      animatedTexts: [
        FadeAnimatedText(
          'Thank you for your order!',
          textStyle: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
      isRepeatingAnimation: true,
    ),
  ],
),

  
),

      
      body: Padding(
        
        
        padding: const EdgeInsets.all(11.0),
        child: Column(
          children: [
             const SizedBox(height: 50),
            Lottie.asset(
              'assets/success2.json',
              height: 300, // Add this file to your assets folder
              width: 300,
              repeat: false,
            ),
            const SizedBox(height: 80),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color.fromARGB(255, 238, 193, 176),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: $name", style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text("Original Price: \$${originalPrice.toStringAsFixed(2)}"),
                    Text("Discount: -\$${discount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green)),
                    const Divider(),
                    Text("Total Paid: \$${finalPrice.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("Transaction ID: $transactionId", style: const TextStyle(color: Colors.brown)),
                  ],
                ),
                
              ),
              
            ),
            SizedBox(height: 90,),

            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
              minWidth: double.infinity,
              height: 50,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Bottombar()));
                

            },
            color: Colors.brown,
            child: Text("Tank You For Your Order",style: TextStyle(color: Colors.white),),)
            
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 253, 235, 229),
    );
  }
}
