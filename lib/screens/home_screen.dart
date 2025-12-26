import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'login_screen.dart';

// --- CONTROLLER FOR STATE MANAGEMENT ---
class HomeController extends GetxController {
  // Reactive integer to track expanded accordion index
  var expandedJuniorIndex = (-1).obs;

  void toggleJunior(int index) {
    if (expandedJuniorIndex.value == index) {
      expandedJuniorIndex.value = -1;
    } else {
      expandedJuniorIndex.value = index;
    }
  }

  // Moved data out of the UI class for cleaner code
  final List<Map<String, dynamic>> juniorCategories = [
    {
      "title": "GIRL (6 YEARS - 14 YEARS)",
      "items": [
        "New",
        "T-Shirts",
        "Sweatshirts & Hoodies",
        "Accessories",
        "Shirts & Shackets",
        "Jackets & Coats",
        "Skirts & Shorts",
        "Dresses & Jumpsuit",
        "Suits",
        "Sweaters",
        "Trousers",
        "Jeans",
        "Shoes",
      ],
    },
    {
      "title": "BOY (6 YEARS - 14 YEARS)",
      "items": [
        "New",
        "Sweatshirts & Hoodies",
        "Accessories",
        "Sweaters",
        "Shorts",
        "Jackets & Coats",
        "T-Shirts",
        "Shirts & Polo's",
        "Suits",
        "Trousers",
        "Jeans",
        "Shoes",
      ],
    },
    {
      "title": "BABY GIRL (3 MONTHS - 5 YEARS)",
      "items": [
        "New",
        "Sweatshirts & Hoodies",
        "Shoes",
        "Accessories",
        "Socks",
        "Sweaters",
      ],
    },
    {
      "title": "BABY BOY (3 MONTHS - 5 YEARS)",
      "items": [
        "New",
        "Sweatshirts & Hoodies",
        "Shoes",
        "Accessories",
        "Socks",
        "Sweaters",
      ],
    },
  ];
}

// --- MAIN WIDGET ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primaryBlue = Color(0xFF0056D2);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: _buildTabbedDrawer(context, controller),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 25),
              _buildPromoBanner(),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Popular Arrivals",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "See All",
                      style: TextStyle(color: primaryBlue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildProductGrid(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildTabbedDrawer(BuildContext context, HomeController controller) {
    return Drawer(
      width: 320,
      child: DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Column(
            children: [
              // Drawer Header with Logo
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: primaryBlue),
                accountName: const Text(
                  "Shopiz Menu",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                accountEmail: const Text("Filter your style"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/Shopiz_Logo.png'),
                  ),
                ),
              ),
              const TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryBlue,
                indicatorWeight: 3,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                tabs: [
                  Tab(text: "Men"),
                  Tab(text: "Women"),
                  Tab(text: "Juniors"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildSimpleList([
                      "New",
                      "View All",
                      "T-Shirts",
                      "Accessories",
                      "Fragrances",
                      "Shoes",
                      "Shorts",
                      "Polo's",
                      "Shirts",
                      "Coat & Blazers",
                      "Jeans",
                      "Trousers",
                    ]),
                    _buildSimpleList([
                      "New",
                      "View All",
                      "T-Shirts",
                      "Bags",
                      "Accessories",
                      "Shirts & Blouses",
                      "Sweatshirts & Hoodies",
                      "Sweaters & Cardigans",
                      "Jeans",
                      "Trousers",
                      "Co-ord Sets",
                    ]),
                    // Pass controller to Accordion
                    _buildJuniorsAccordion(controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJuniorsAccordion(HomeController controller) {
    // Using ListView.separated as requested for cleaner list rendering
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: controller.juniorCategories.length,
      separatorBuilder: (ctx, i) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final category = controller.juniorCategories[index];

        // Obx makes this specific part of the UI rebuild when expandedJuniorIndex changes
        return Obx(() {
          final bool isExpanded = controller.expandedJuniorIndex.value == index;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  category["title"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                trailing: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: primaryBlue,
                ),
                onTap: () => controller.toggleJunior(index),
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (category["items"] as List<String>).map((item) {
                      final isSpecial = item == "New";
                      return InkWell(
                        onTap: () => Get.back(), // GetX Navigation
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSpecial
                                  ? Colors.red[700]
                                  : Colors.black87,
                              fontWeight: isSpecial
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          );
        });
      },
    );
  }

  Widget _buildSimpleList(List<String> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSpecial = item == "New";
        return ListTile(
          visualDensity: const VisualDensity(vertical: -2),
          title: Text(
            item,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSpecial ? FontWeight.bold : FontWeight.normal,
              color: isSpecial ? Colors.red[700] : Colors.black87,
            ),
          ),
          onTap: () => Get.back(),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black87),
      centerTitle: false, // Fix overflow by not forcing center alignment
      titleSpacing: 0, // Reduce spacing since we are left aligning
      // UPDATED: Using a Row to show both Logo and Text
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Image.asset('assets/images/Shopiz_Logo.png', height: 50),
          ),
          const SizedBox(width: 4),
          const Text(
            "Shopiz",
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: OutlinedButton.icon(
            onPressed: () {
              // Optimized Navigation
              Get.to(() => const LoginScreen());
            },
            icon: const Icon(Icons.person, size: 18),
            label: const Text("Login"),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryBlue,
              side: const BorderSide(color: primaryBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black87),
          onPressed: () {},
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  // Search Bar and Promo Banner helper methods remain largely the same, just keeping them concise
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search items...",
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search, color: primaryBlue),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0056D2), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "New Collection",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Summer Sale\n40% OFF",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Shop Now"),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white24,
            size: 80,
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      // Adjusted aspect ratio to 0.7 to prevent overflow in grid tiles
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.7,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  width: double.infinity,
                  child: Icon(Icons.image, size: 50, color: Colors.grey[300]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Classic Item #$index",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "\$45.00",
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 16,
                            color: primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
