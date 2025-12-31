import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:get/get.dart'; 
import 'login_screen.dart'; 
import 'main_screen.dart'; 
import 'shopping_screen.dart'; 
import 'item_view_screen.dart';
import '../models/product_model.dart';
import '../constants.dart';

class HomeController extends GetxController {
  // Drawer Logic
  var expandedJuniorIndex = (-1).obs;
  
  // Carousel Logic
  var currentBannerIndex = 0.obs;
  final PageController pageController = PageController(viewportFraction: 0.85);

  void toggleJunior(int index) {
    if (expandedJuniorIndex.value == index) {
      expandedJuniorIndex.value = -1;
    } else {
      expandedJuniorIndex.value = index;
    }
  }
  
  void updateBannerIndex(int index) {
    currentBannerIndex.value = index;
  }

  void resetBanner() {
    currentBannerIndex.value = 0;
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
  }

  final List<Map<String, dynamic>> juniorCategories = [
    {
      "title": "GIRL (6 YEARS - 14 YEARS)",
      "items": ["New", "T-Shirts", "Sweatshirts & Hoodies", "Accessories", "Shirts & Shackets", "Jackets & Coats", "Skirts & Shorts", "Dresses & Jumpsuit", "Suits", "Sweaters", "Trousers", "Jeans", "Shoes"]
    },
    {
      "title": "BOY (6 YEARS - 14 YEARS)",
      "items": ["New", "Sweatshirts & Hoodies", "Accessories", "Sweaters", "Shorts", "Jackets & Coats", "T-Shirts", "Shirts & Polo's", "Suits", "Trousers", "Jeans", "Shoes"]
    },
    {
      "title": "BABY GIRL (3 MONTHS - 5 YEARS)",
      "items": ["New", "Sweatshirts & Hoodies", "Shoes", "Accessories", "Socks", "Sweaters"]
    },
    {
      "title": "BABY BOY (3 MONTHS - 5 YEARS)",
      "items": ["New", "Sweatshirts & Hoodies", "Shoes", "Accessories", "Socks", "Sweaters"]
    }
  ];
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Helper to switch to Shop tab and apply filters
  void _navigateToShop({
    String? gender, 
    String? category, 
    String? subCategory, 
    String? search,
    bool closeDrawer = false
  }) {
    final MainController mainController = Get.find<MainController>();
    
    // Ensure ShoppingController is loaded
    final ShoppingController shopController = Get.isRegistered<ShoppingController>() 
        ? Get.find<ShoppingController>() 
        : Get.put(ShoppingController());

    shopController.resetFilters();
    
    if (search != null) {
      shopController.searchQuery.value = search;
    }
    
    if (gender != null) {
      shopController.selectedGenders.add(gender);
    }
    
    if (category != null) {
      shopController.selectedCategories.add(category);
    }

    if (subCategory != null) {
      // Check if the item passed as subCategory is actually a Main Category
      if (["Clothes", "Watches", "Belts", "Perfumes"].contains(subCategory)) {
        shopController.selectedCategories.add(subCategory);
      } else {
        shopController.selectedSubCategories.add(subCategory);
      }
    }
    
    shopController.applyFilters();
    
    if (closeDrawer) {
      Get.back(); // Close Drawer
    }
    
    mainController.changeTab(1); // Switch to Shop Tab
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    // Ensure ShoppingController is available for featured products
    final ShoppingController shopController = Get.isRegistered<ShoppingController>() 
        ? Get.find<ShoppingController>() 
        : Get.put(ShoppingController());

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: _buildPremiumDrawer(context, controller),
      body: CustomScrollView(
        slivers: [
          _buildPremiumSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildPremiumHeroSection(controller),
                const SizedBox(height: 40),
                _buildPremiumCategoriesSection(),
                const SizedBox(height: 40),
                _buildSectionTitle("Trending Now", ""),
                const SizedBox(height: 20),
                _buildPremiumFeaturedProducts(shopController),
                const SizedBox(height: 40),
                _buildSectionTitle("Collections", "Curated for you"),
                const SizedBox(height: 20),
                _buildPremiumCollections(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- PREMIUM WIDGETS ---

  Widget _buildPremiumSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.surface.withOpacity(0.95),
      elevation: 0,
      floating: true,
      pinned: true,
      centerTitle: true,
      toolbarHeight: 60,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: AppColors.secondary, size: 28),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Text(
        "Shopiz", 
        style: GoogleFonts.playfairDisplay(
          fontSize: 26, 
          fontWeight: FontWeight.w900, 
          letterSpacing: 1.2,
          color: AppColors.secondary,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => Get.to(() => const LoginScreen()),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.secondary, width: 1.5),
              ),
              child: const Icon(Icons.person_outline, color: AppColors.secondary, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumHeroSection(HomeController controller) {
    final banners = [
      {
        "image": "assets/images/winter_banner.png",
        "title": "WINTER\nCOLLECTION",
        "btnText": "SHOP NOW",
        "action": () => _navigateToShop(subCategory: "Jackets & Coats"),
      },
      {
        "image": "assets/images/new_arrivals_banner.png",
        "title": "NEW\nARRIVALS",
        "btnText": "VIEW ALL",
        "action": () => _navigateToShop(), 
      },
      {
        "image": "assets/images/accessories_banner.png",
        "title": "EXCLUSIVE\nACCESSORIES",
        "btnText": "EXPLORE",
        "action": () => _navigateToShop(category: "Accessories"),
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.updateBannerIndex,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return AnimatedBuilder(
                animation: controller.pageController,
                builder: (context, child) {
                  double value = 0.0;
                  if (controller.pageController.position.haveDimensions) {
                     value = index.toDouble() - (controller.pageController.page ?? 0);
                     value = value.clamp(-1, 1);
                  }
                  final scale = Curves.easeOut.transform(1 - (value.abs() * 0.15));
                  final opacity = (1 - (value.abs() * 0.3)).clamp(0.5, 1.0);
                  
                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: child,
                    ),
                  );
                },
                child: GestureDetector(
                  onTap: banner["action"] as VoidCallback,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10), // Margin for spacing between items since viewportFraction is 0.9 or we use full width
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              banner["image"] as String,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.8),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  stops: const [0.0, 0.6],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 24,
                            left: 24,
                            right: 24, // Keep right constraint to prevent overflow
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  banner["title"] as String,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.playfairDisplay(
                                    color: Colors.white,
                                    fontSize: 28, // Slightly smaller for better balance
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                    height: 1.1,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GestureDetector(
                                  onTap: banner["action"] as VoidCallback, // Ensure button also triggers action
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2), // Glassmorphic button
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.white.withOpacity(0.5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          banner["btnText"] as String,
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: controller.currentBannerIndex.value == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: controller.currentBannerIndex.value == index 
                  ? AppColors.secondary 
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          )),
        )),
      ],
    );
  }

  Widget _buildPremiumBannerCard(String title, String subtitle, List<Color> colors, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Stack(
              children: [
                Positioned(
                  right: -30,
                  bottom: -30,
                  child: Icon(icon, size: 200, color: Colors.white.withOpacity(0.1)),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 32),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        title, 
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 28, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle, 
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9), 
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Shop Now", 
                              style: TextStyle(
                                color: colors.last, 
                                fontWeight: FontWeight.bold, 
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: colors.last, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumCategoriesSection() {
    final categories = [
      {"name": "Men", "icon": Icons.man},
      {"name": "Women", "icon": Icons.woman},
      {"name": "Juniors", "icon": Icons.child_care},
    ];

    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: categories.map((cat) {
          return GestureDetector(
            onTap: () {
              if (cat["name"] == "Men") _navigateToShop(gender: "Men");
              if (cat["name"] == "Women") _navigateToShop(gender: "Women");
              if (cat["name"] == "Juniors") _navigateToShop(gender: "Juniors (Boy)");
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.secondary, width: 2),
                  ),
                  child: Icon(cat["icon"] as IconData, color: AppColors.secondary, size: 36),
                ),
                const SizedBox(height: 12),
                Text(
                  cat["name"] as String, 
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w600, 
                    fontSize: 14, 
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold, 
                  color: AppColors.secondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle, 
                style: TextStyle(
                  fontSize: 14, 
                  color: AppColors.textSecondary.withOpacity(0.8),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => _navigateToShop(),
            child: Row(
              children: [
                Text(
                  "See All", 
                  style: GoogleFonts.lato(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, color: AppColors.secondary, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFeaturedProducts(ShoppingController shopController) {
    final featuredProducts = [
      {
        "name": "Cashmere Sweater",
        "price": "\$20.00",
        "image": "assets/images/cashmere_sweater.png",
      },
      {
        "name": "Leather Boots",
        "price": "\$50.00",
        "image": "assets/images/leather_boots.png",
      },
      {
        "name": "Silk Scarf",
        "price": "\$20.00",
        "image": "assets/images/silk_scarf.png",
      },
    ];

    return SizedBox(
      height: 240,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: featuredProducts.map((product) {
          return Container(
            width: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        product["image"] as String,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        product["name"] as String,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product["price"] as String,
                        style: GoogleFonts.lato(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPremiumCollections() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildPremiumCollectionTile(
            "The Denim Edit", 
            "Jeans, Jackets & More", 
            [AppColors.primary, AppColors.primary.withOpacity(0.7)],
            Icons.checkroom, 
            height: 200,
            imagePath: "assets/images/denim_collection.jpg",
            onTap: () => _navigateToShop(subCategory: "Jeans")
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPremiumCollectionTile(
                  "Activewear", 
                  "Gym Ready", 
                  [const Color(0xFF00796B), const Color(0xFF004D40)],
                  Icons.fitness_center,
                  height: 180,
                  imagePath: "assets/images/activewear_collection.png",
                  onTap: () => _navigateToShop(subCategory: "Activewear")
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPremiumCollectionTile(
                  "Perfumes", 
                  "Signature Scents", 
                  [AppColors.secondary, AppColors.secondary.withOpacity(0.7)],
                  Icons.spa,
                  height: 180,
                  imagePath: "assets/images/perfume_collection.png",
                  onTap: () => _navigateToShop(category: "Perfumes")
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCollectionTile(
    String title, 
    String subtitle, 
    List<Color> colors, 
    IconData icon, 
    {double height = 140, String? imagePath, required VoidCallback onTap}
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          image: imagePath != null ? DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ) : null,
          gradient: imagePath == null ? LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ) : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container( // Changed from BackdropFilter/Stack for simpler image overlay
            decoration: BoxDecoration(
              gradient: imagePath != null ? LinearGradient(
                colors: [
                  Colors.transparent, 
                  Colors.black.withOpacity(0.7)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ) : null,
            ),
            child: Stack(
              children: [
                if (imagePath == null) // Only show giant icon if no image
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Icon(icon, color: Colors.white.withOpacity(0.15), size: 120),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Hide small icon if image is present for cleaner look
                      if (imagePath == null) Icon(icon, color: Colors.white, size: 32),
                      if (imagePath != null) const SizedBox(height: 32), // Spacer to push text down
                      const SizedBox(height: 12),
                      Text(
                        title, 
                        style: GoogleFonts.playfairDisplay( // Upgraded font
                          color: Colors.white, 
                          fontSize: 22, 
                          fontWeight: FontWeight.bold,
                          shadows: imagePath != null ? [const Shadow(blurRadius: 10, color: Colors.black)] : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle, 
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9), 
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- PREMIUM DRAWER ---
  Widget _buildPremiumDrawer(BuildContext context, HomeController controller) {
    return Drawer(
      width: 320,
      backgroundColor: AppColors.surface,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.surface,
              AppColors.surface.withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: DefaultTabController(
          length: 3,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Shopiz", 
                            style: TextStyle(
                              fontSize: 24, 
                              fontWeight: FontWeight.bold, 
                              color: AppColors.secondary,
                            ),
                          ),
                          Text(
                            "Explore your style", 
                            style: TextStyle(
                              fontSize: 13, 
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.divider.withOpacity(0.3), width: 1),
                    ),
                  ),
                  child: TabBar(
                    labelColor: AppColors.secondary,
                    unselectedLabelColor: AppColors.textTertiary,
                    indicatorColor: AppColors.secondary,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    tabs: const [
                      Tab(text: "Men"), 
                      Tab(text: "Women"), 
                      Tab(text: "Juniors"),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildSimpleList([
                        "New", "View All", "T-Shirts", "Accessories", "Perfumes", "Shoes", 
                        "Shorts", "Polo's", "Shirts", "Coat & Blazers", "Jeans", "Trousers"
                      ], gender: "Men"),
                      _buildSimpleList([
                        "New", "View All", "T-Shirts", "Bags", "Accessories", "Shirts & Blouses", 
                        "Sweatshirts & Hoodies", "Sweaters & Cardigans", "Jeans", "Trousers", "Co-ord Sets"
                      ], gender: "Women"),
                      _buildJuniorsAccordion(controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJuniorsAccordion(HomeController controller) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: controller.juniorCategories.length,
      separatorBuilder: (ctx, i) => Divider(
        height: 1, 
        indent: 20, 
        endIndent: 20, 
        color: AppColors.divider.withOpacity(0.3),
      ),
      itemBuilder: (context, index) {
        final category = controller.juniorCategories[index];
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
                    color: AppColors.textTertiary,
                  ),
                ),
                trailing: Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.secondary,
                ),
                onTap: () => controller.toggleJunior(index),
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 10),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (category["items"] as List<String>).map((item) {
                      final isSpecial = item == "New";
                      return InkWell(
                        onTap: () {
                          String gender = "Juniors (Boy)";
                          if (category["title"].toString().contains("GIRL")) gender = "Juniors (Girl)";
                          if (category["title"].toString().contains("BOY") && !category["title"].toString().contains("GIRL")) gender = "Juniors (Boy)";
                          
                          _navigateToShop(gender: gender, subCategory: item, closeDrawer: true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: isSpecial 
                              ? LinearGradient(colors: [AppColors.secondary, AppColors.secondary.withOpacity(0.7)])
                              : null,
                            color: isSpecial ? null : AppColors.surface.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSpecial ? AppColors.secondary.withOpacity(0.5) : AppColors.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 13,
                              color: isSpecial ? Colors.white : AppColors.textTertiary,
                              fontWeight: isSpecial ? FontWeight.bold : FontWeight.normal,
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

  Widget _buildSimpleList(List<String> items, {required String gender}) {
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
              color: isSpecial ? AppColors.secondary : AppColors.textTertiary,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios, 
            size: 14, 
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          onTap: () => _navigateToShop(gender: gender, subCategory: item, closeDrawer: true),
        );
      },
    );
  }
}
