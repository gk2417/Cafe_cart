import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ItemProfileScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Dashboard extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {
      'name':'Cappuccino',
      'description':'A cappuccino is a coffee drink made with espresso, steamed milk, and milk foam. It is known for its balanced flavor profile, creamy texture, and characteristic foam layer. Typically, a cappuccino consists of roughly equal thirds of espresso, steamed milk, and milk foam, though the exact proportions can vary ',
      'price': '\$10.00',
      'rating': '4.5',
      'image': 'assets/item1.jpg',
    },
    {
      'name': 'Chocolate   ',
      'description':'Chocolate coffee, often called mocha, is a delightful beverage that combines the rich, bold taste of coffee with the sweetness and depth of chocolate. Its typically made with espresso, steamed milk, and chocolate syrup or cocoa powder, offering a balanced, luxurious drink that can be enjoyed hot or cold.  ',
      'price': '\$15.00',
      'rating': '4.2',
      'image': 'assets/item2.jpg',
    },
    {
      'name': 'Chai             ',
      'description':'Chai, also known as masala chai, is a spiced tea beverage popular in South Asia and increasingly worldwide. It s made by brewing black tea with milk, sugar, and a blend of aromatic spices. The spices typically include cinnamon, cardamom, cloves, ginger, and black peppercorns, but variations exist across different regions and families.  ',
      'price': '\$2.00',
      'rating': '4.8',
      'image': 'assets/item3.jpg',
    },
    {
      'name': 'Masala        ',
      'description':'Chai, also known as masala chai, is a spiced tea beverage popular in South Asia and increasingly worldwide. Its made by brewing black tea with milk, sugar, and a blend of aromatic spices. The spices typically include cinnamon, cardamom, cloves, ginger, and black peppercorns, but variations exist across different regions and families. ',
      'price': '\$3.44',
      'rating': '4.8',
      'image': 'assets/item4.jpg',
    },
     {
      'name': 'Cookies       ',
      'description':'Cookies, in a general sense, can refer to small, flat, sweet baked goods made from flour, sugar, and fat, often with added ingredients like chocolate chips, nuts, or dried fruit. Cookies are commonly enjoyed as a snack or dessert. However, the term "cookie" also refers to small text files that websites store on users browsers to remember information about their visits, like login details or preferences.  ',
      'price': '\$12.22',
      'rating': '4.8',
      'image': 'assets/item5.jpg',
    },
    {
      'name': 'Oreo            ',
      'description':'Oreo cookies are a classic American sandwich cookie, consisting of two chocolate wafers with a sweet, creamy filling, traditionally vanilla flavored. They are known for being "supremely dunkable" in milk and come in various flavors and sizes.',
      'price': '\$20.00',
      'rating': '4.8',
      'image': 'assets/item6.jpg',
    },
  ];

final List<Map<String, dynamic>> cake = [
    {
      'name':'Strawberry   ',
      'description':'Strawberry cakes may be prepared \n with strawberries in the batter, with strawberries atop them, with strawberries or a strawberry filling in between the layers of a layer cake, and in any combination thereof. Some are prepared with strawberries incorporated into a frosting. Fresh or frozen strawberries ',
      'price': '\$205.0',
      'rating': '5.0',
      'image': 'assets/cake6.jpg',
    },
    {
      'name': 'Chocolate   ',
      'description':'Chocolate cake is a sweet dessert flavored with melted chocolate, cocoa powder, or both. It s known for its rich, chocolatey taste and moist texture, often layered with frosting or filling. The flavor and texture can vary based on ingredients and baking methods, ranging from simple sheet cakes to elaborate layer cakes. ',
      'price': '\$99.00',
      'rating': '4.7',
      'image': 'assets/cake1.jpg',
    },
    {
      'name': 'ice cream  ',
      'description':'An ice cream cake is a dessert that combines layers of cake with ice cream, often with additional elements like frosting, cookies, or sauces. It can be made with a baked cake base or as a no-bake layered dessert using ice cream and other ingredients',
      'price': '\$22.00',
      'rating': '3.8',
      'image': 'assets/cake5.jpg',
    },
    {
      'name': 'birthday   ',
      'description':'An ice cream cake is a dessert that combines layers of cake with ice cream, often with additional elements like frosting, cookies, or sauces. It can be made with a baked cake base or as a no-bake layered dessert using ice cream and other ingredients',
      'price': '\$103.4',
      'rating': '4.8',
      'image': 'assets/cake3.jpg',
    },
     {
      'name': 'brownie  ',
      'description':'A brownie cake is a type of cake made with brownie batter, resulting in a rich, dense, and fudgy dessert. It often has a cracked, meringue-like crust and a fudgy center. Some variations incorporate layers of frosting and ganache, similar to a layer cake. Essentially',
      'price': '\$82.22',
      'rating': '4.2',
      'image': 'assets/cake4.jpg',
    },
    {
      'name': 'Milk cream  ',
      'description':'Milk cake (also known as Alwar Ka Mawa) is a popular Indian sweet (mithai) that s got a unique grainy texture and caramelized milky flavour. It s soft, rich, dense, moist and melts in your mouth. It s mainly made of milk and sugar, topped with nuts and visibly distinct due to it s gradient shade.',
      'price': '\$50.00',
      'rating': '4.8',
      'image': 'assets/cake2.jpg',
    },
  ];
  final List<Map<String, dynamic>> juice = [
    {
      'name':'lemon        ',
      'description':'Lemon juice is the sour, acidic liquid extracted from lemons, known for its vibrant citrus flavor and high vitamin C content. Its a versatile ingredient used in both culinary and non-culinary applications, from flavoring beverages and dishes to acting as a natural cleaning agent. ',
      'price': '\$205.0',
      'rating': '5.0',
      'image': 'assets/juice1.jpg',
    },
    {
      'name': 'mango      ',
      'description':'Mango juice is a refreshing and flavorful beverage made from the pulp of ripe mangoes, often mixed with water and sometimes sweeteners. It s a popular way to enjoy the taste of mangoes, known as the "king of fruits, in a convenient, drinkable form. The juice can range from a clear ',
      'price': '\$99.00',
      'rating': '4.7',
      'image': 'assets/juice2.jpg',
    },
    {
      'name': 'watermelon',
      'description':'Watermelon juice is excellent and made of watermelon fruit and a savior to many during the hot scorching summer. This is a subtly crunchy thirst quenching fruit and are found in the markets throughout the year but are the best and very sweet during the peak summer season. ',
      'price': '\$22.00',
      'rating': '3.8',
      'image': 'assets/juice3.jpg',
    },
    {
      'name': 'strawberry  ',
      'description':'Strawberry cakes may be prepared \n with strawberries in the batter, with strawberries atop them, with strawberries or a strawberry filling in between the layers of a layer cake, and in any combination thereof. Some are prepared with strawberries incorporated into a frosting. Fresh or frozen strawberries ',
      'price': '\$103.4',
      'rating': '4.8',
      'image': 'assets/juice7.jpg',
    },
     {
      'name': 'apple         ',
      'description':'Apple juice is a refreshing and widely enjoyed fruit juice made from apples. Its produced by extracting juice from the pulp of apples, which are then filtered and often pasteurized to ensure safety and shelf stability. Apple juice is known for its sweet and tangy flavor, derived from the natural sugars present in apples.  ',
      'price': '\$82.22',
      'rating': '4.2',
      'image': 'assets/juice5.jpg',
    },
    {
      'name': 'orange        ',
      'description':'Orange juice is a popular beverage made from the liquid extract of oranges. Its known for its refreshing taste and is a good source of Vitamin C and other nutrients. It can be enjoyed fresh, or purchased in various forms like bottled, canned, or frozen.  ',
      'price': '\$50.00',
      'rating': '4.8',
      'image': 'assets/juice6.jpg',
    },
  ];

  
@override
Widget build(BuildContext context) {
  // ignore: unused_local_variable
  final screenWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 253, 235, 229),
    body: SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search items...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 238, 213, 205),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Animated greeting text
              AnimatedTextKit(
  isRepeatingAnimation: false,
  animatedTexts: [
    TypewriterAnimatedText(
      'Good Morning ... \nFind the best Coffee for you ....',
      textStyle: GoogleFonts.anta(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.brown[800],
      ),
      speed: const Duration(milliseconds: 60),
    ),
  ],
),

              const SizedBox(height: 20),

              // Carousel
              SizedBox(
                height: 200,
                width: double.infinity,
                child: AnotherCarousel(
                  images: const [
                    AssetImage("assets/tea1.jpg"),
                    AssetImage("assets/biscat2.jpg"),
                    AssetImage("assets/item3.jpg"),
                    AssetImage("assets/biscat.jpg"),
                    AssetImage("assets/coffe1.jpg"),
                    AssetImage("assets/coffe2.jpg"),
                  ],
                  dotSize: 6,
                  indicatorBgPadding: 5.0,
                  borderRadius: true,
                ),
              ),

              const SizedBox(height: 20),
              _buildSection(context, "Coffee Collection", items),
              const SizedBox(height: 25),
              _buildSection(context, "Cake Delights", cake),
              const SizedBox(height: 25),
              _buildSection(context, "Favorite Drinks", juice),

              const SizedBox(height: 30),

              // Coming Soon Banner
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 190,
                      child: Image.asset("assets/coming1.jpg", fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: LottieBuilder.asset(
                        "assets/com.json",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

// Reusable item section
Widget _buildSection(BuildContext context, String title, List<Map<String, dynamic>> itemList) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_drink_sharp),
          Text(
            " $title ",
            style: const TextStyle(
              color: Color.fromARGB(255, 88, 36, 29),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: itemList.length,
          itemBuilder: (context, index) {
            final item = itemList[index];
            return Container(
              width: 150,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Card(
                color: const Color.fromARGB(255, 255, 225, 218),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemProfileScreen(item: item),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.asset(
                          item['image'],
                          height: 90,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['name'],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(Icons.favorite_border_outlined, color: Colors.red, size: 16),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item['price']),
                                Row(
                                  children: [
                                    const Icon(Icons.star_outlined, color: Colors.orange, size: 16),
                                    Text(item['rating']),
                                  ],
                                ),
                              ],
                            ),
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
    ],
  );
}

}