import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart'; 
import 'item_view_screen.dart';
import '../constants.dart';

// --- CONTROLLER (LOGIC) ---
class ShoppingController extends GetxController {
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> displayedProducts = <Product>[].obs;

  final RxBool isGridView = true.obs;
  final RxString sortBy = 'Newest'.obs;
  
  // Filter Settings
  final RxString searchQuery = ''.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 500.0.obs;
  final RxList<String> selectedGenders = <String>[].obs;
  
  // Unified Filter List (Matches Home Screen Drawer)
  final RxList<String> selectedFilters = <String>[].obs;

  // The complete list of categories from your Home Screen Drawer
  final List<String> allFilterOptions = [
    "New", "View All", 
    "T-Shirts", "Shirts", "Polo's", "Shirts & Blouses", "Shirts & Polo's", "Shirts & Shackets",
    "Sweatshirts & Hoodies", "Sweaters & Cardigans", "Sweaters",
    "Jackets & Coats", "Jackets", "Jackets & Over Shirts", "Coat & Blazers",
    "Jeans", "Trousers", "Shorts", "Skirts & Shorts", "Dresses & Jumpsuits", "Suits", "Co-ord Sets", 
    "Activewear", "Activewears",
    "Shoes", "Socks",
    "Bags", "Accessories", "Jewellery",
    "Watches", "Perfumes", "Belts"
  ];

  @override
  void onInit() {
    super.onInit();
    generateDummyProducts();
  }

  void resetFilters() {
    searchQuery.value = '';
    minPrice.value = 0.0;
    maxPrice.value = 500.0;
    selectedGenders.clear();
    selectedFilters.clear(); // Clear unified filters
    
    if (allProducts.isEmpty) generateDummyProducts();
    applyFilters(); 
  }

  void toggleView() => isGridView.value = !isGridView.value;

  void sortProducts(String? sortType) {
    sortBy.value = sortType ?? 'Newest';
    switch (sortBy.value) {
      case 'Price: Low to High':
        displayedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        displayedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Newest':
        displayedProducts.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
        break;
    }
  }

  void applyFilters() {
    if (allProducts.isEmpty) generateDummyProducts();

    var temp = allProducts.where((p) {
      // 1. Search Query
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        if (!p.name.toLowerCase().contains(query) && 
            !p.subCategory.toLowerCase().contains(query) &&
            !p.category.toLowerCase().contains(query)) {
          return false;
        }
      }
      
      // 2. Price Range
      if (p.price < minPrice.value || p.price > maxPrice.value) {
        return false;
      }
      
      // 3. Gender Filter
      if (selectedGenders.isNotEmpty) {
        // Direct match (Men, Women, Juniors (Boy), Juniors (Girl))
        if (!selectedGenders.contains(p.gender)) {
          return false;
        }
      }
      
      // 4. Unified Category/SubCategory Filter
      if (selectedFilters.isNotEmpty) {
        // Special Logic: "View All" matches everything
        if (selectedFilters.contains("View All")) {
          return true; 
        }

        bool match = false;
        for (var filter in selectedFilters) {
          // Special Logic: "New" matches recent items (simulated as items added within last 7 days)
          // For dummy data, we'll just allow it to match everything that passed other filters
          if (filter == "New") {
             // Optional: Add logic like p.dateAdded.isAfter(...)
             match = true;
             break;
          }

          if (p.category.toLowerCase() == filter.toLowerCase() || 
              p.subCategory.toLowerCase() == filter.toLowerCase()) {
            match = true;
            break;
          }
          
          // Alias matching for messy data
          if (filter == "Perfumes" && p.subCategory == "Fragrances") match = true;
          if (filter.contains("Jackets") && p.subCategory.contains("Jackets")) match = true;
        }
        if (!match) return false;
      }
      
      return true;
    }).toList();

    displayedProducts.assignAll(temp);
    sortProducts(sortBy.value);
  }

  // Getters for compatibility
  get selectedSubCategories => selectedFilters;
  get selectedCategories => selectedFilters; 

  void generateDummyProducts() {
    if (allProducts.isNotEmpty) return;

    final List<Product> dummy = [
      // --- MEN ---
      Product(
        id: '1', name: "Men's Classic Polo", description: "Premium cotton.", price: 25.0,
        imageUrls: ["https://via.placeholder.com/300?text=Polo"], 
        gender: "Men", category: "Clothes", subCategory: "Polo's", season: "Summer",
        sizes: ["M", "L"], colors: [Colors.blue], rating: 4.5, dateAdded: DateTime.now()
      ),
      Product(
        id: '2', name: "Slim Fit Jeans", description: "Dark wash.", price: 45.0,
        imageUrls: ["https://via.placeholder.com/300?text=Jeans"], 
        gender: "Men", category: "Clothes", subCategory: "Jeans", season: "All-Season",
        sizes: ["32", "34"], colors: [Colors.blueAccent], rating: 4.7, dateAdded: DateTime.now().subtract(const Duration(days: 1))
      ),
      Product(
        id: '3', name: "Gold Analog Watch", description: "Classic timepiece.", price: 150.0, originalPrice: 200.0,
        imageUrls: ["https://via.placeholder.com/300?text=Watch"], 
        gender: "Men", category: "Watches", subCategory: "Watches", season: "All-Season",
        sizes: [], colors: [Colors.amber], rating: 4.9, dateAdded: DateTime.now().subtract(const Duration(days: 2))
      ),
      Product(
        id: '4', name: "Leather Belt", description: "Genuine leather.", price: 35.0,
        imageUrls: ["https://via.placeholder.com/300?text=Belt"], 
        gender: "Men", category: "Belts", subCategory: "Accessories", season: "All-Season",
        sizes: [], colors: [Colors.brown], rating: 4.6, dateAdded: DateTime.now().subtract(const Duration(days: 10))
      ),
      Product(
        id: '12', name: "Men's Hoodie", description: "Fleece lined.", price: 55.0,
        imageUrls: ["https://via.placeholder.com/300?text=Hoodie"], 
        gender: "Men", category: "Clothes", subCategory: "Sweatshirts & Hoodies", season: "Winter",
        sizes: ["L", "XL"], colors: [Colors.grey], rating: 4.8, dateAdded: DateTime.now()
      ),

      // --- WOMEN ---
      Product(
        id: '6', name: "Floral Dress", description: "Summer vibes.", price: 45.0,
        imageUrls: ["https://via.placeholder.com/300?text=Dress"], 
        gender: "Women", category: "Clothes", subCategory: "Dresses & Jumpsuits", season: "Summer",
        sizes: ["S", "M"], colors: [Colors.pink], rating: 4.2, dateAdded: DateTime.now().subtract(const Duration(days: 5))
      ),
      Product(
        id: '8', name: "Yoga Leggings", description: "High stretch.", price: 30.0,
        imageUrls: ["https://via.placeholder.com/300?text=Activewear"], 
        gender: "Women", category: "Clothes", subCategory: "Activewear", season: "All-Season",
        sizes: ["S", "M"], colors: [Colors.black], rating: 4.5, dateAdded: DateTime.now().subtract(const Duration(days: 4))
      ),
      Product(
        id: '9', name: "Eau de Parfum", description: "Rose & Jasmine.", price: 85.0, originalPrice: 100.0,
        imageUrls: ["https://via.placeholder.com/300?text=Perfume"], 
        gender: "Women", category: "Perfumes", subCategory: "Fragrances", season: "All-Season",
        sizes: ["50ml"], colors: [], rating: 4.9, dateAdded: DateTime.now()
      ),
      Product(
        id: '13', name: "Co-ord Set", description: "Matching top and bottom.", price: 60.0,
        imageUrls: ["https://via.placeholder.com/300?text=Coord"], 
        gender: "Women", category: "Clothes", subCategory: "Co-ord Sets", season: "Summer",
        sizes: ["M"], colors: [Colors.green], rating: 4.4, dateAdded: DateTime.now()
      ),

      // --- JUNIORS (Updated with specific genders) ---
      Product(
        id: '10', name: "Kids Graphic Tee", description: "100% Cotton.", price: 15.0,
        imageUrls: ["https://via.placeholder.com/300?text=Tee"], 
        gender: "Juniors (Boy)", category: "Clothes", subCategory: "T-Shirts", season: "Summer",
        sizes: ["6Y", "8Y"], colors: [Colors.red], rating: 4.4, dateAdded: DateTime.now()
      ),
      Product(
        id: '11', name: "Boys Jacket", description: "Rugged outerwear.", price: 40.0,
        imageUrls: ["https://via.placeholder.com/300?text=Jacket"], 
        gender: "Juniors (Boy)", category: "Clothes", subCategory: "Jackets & Coats", season: "Winter",
        sizes: ["10Y", "12Y"], colors: [Colors.blue], rating: 4.6, dateAdded: DateTime.now()
      ),
      Product(
        id: '14', name: "Girls Summer Dress", description: "Floral pattern.", price: 25.0,
        imageUrls: ["https://via.placeholder.com/300?text=GirlDress"], 
        gender: "Juniors (Girl)", category: "Clothes", subCategory: "Dresses & Jumpsuits", season: "Summer",
        sizes: ["6Y", "8Y"], colors: [Colors.pinkAccent], rating: 4.5, dateAdded: DateTime.now()
      ),
      Product(
        id: '15', name: "Baby Romper", description: "Soft cotton.", price: 12.0,
        imageUrls: ["https://via.placeholder.com/300?text=Romper"], 
        gender: "Juniors (Boy)", category: "Clothes", subCategory: "Baby Clothes", season: "All-Season",
        sizes: ["3M", "6M"], colors: [Colors.blue[100]!], rating: 4.8, dateAdded: DateTime.now()
      ),
    ];
    
    allProducts.assignAll(dummy);
    displayedProducts.assignAll(dummy);
  }
}

// --- UI SCREEN ---
class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ShoppingController controller = Get.put(ShoppingController());

    return Scaffold(
      backgroundColor: AppColors.background,
      endDrawer: _buildFilterDrawer(controller),
      appBar: AppBar(
        title: const Text("Shopiz Store", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false, 
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: AppColors.textPrimary), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.textPrimary), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: AppColors.surface,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.divider),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(() => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.sortBy.value,
                        isExpanded: true,
                        dropdownColor: AppColors.surface,
                        icon: const Icon(Icons.sort, size: 20, color: AppColors.textPrimary),
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        items: ['Newest', 'Price: Low to High', 'Price: High to Low']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => controller.sortProducts(val),
                      ),
                    )),
                  ),
                ),
                const SizedBox(width: 10),
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    tooltip: "Filter",
                  ),
                ),
                Obx(() => IconButton(
                  icon: Icon(controller.isGridView.value ? Icons.view_list : Icons.grid_view),
                  onPressed: () => controller.toggleView(),
                  color: AppColors.primary,
                )),
              ],
            ),
          ),
          
          Expanded(
            child: Obx(() {
              if (controller.displayedProducts.isEmpty) {
                return const Center(child: Text("No items found", style: TextStyle(color: AppColors.textSecondary)));
              }
              
              return controller.isGridView.value
                  ? _buildGridView(controller)
                  : _buildListView(controller);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(ShoppingController controller) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65, 
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: controller.displayedProducts.length,
      itemBuilder: (context, index) {
        final product = controller.displayedProducts[index];
        return _buildProductCard(product, isGrid: true);
      },
    );
  }

  Widget _buildListView(ShoppingController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: controller.displayedProducts.length,
      itemBuilder: (context, index) {
        final product = controller.displayedProducts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _buildProductCard(product, isGrid: false),
        );
      },
    );
  }

  Widget _buildProductCard(Product product, {required bool isGrid}) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ItemViewScreen(product: product));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5, spreadRadius: 1)],
        ),
        child: isGrid
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildImage(product)),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(height: 5),
                        _buildPriceRow(product),
                      ],
                    ),
                  ),
                ],
              )
            : Row( 
                children: [
                  SizedBox(width: 120, height: 120, child: _buildImage(product)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                          const SizedBox(height: 5),
                          Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          const SizedBox(height: 10),
                          _buildPriceRow(product),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildImage(Product product) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            image: DecorationImage(
              image: NetworkImage(product.imageUrls.first), 
              fit: BoxFit.cover,
            ),
          ),
          child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)), 
        ),
        if (product.isOnSale)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(5)),
              child: Text("-${product.discountPercent}%", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceRow(Product product) {
    return Row(
      children: [
        Text("\$${product.price}", style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
        if (product.isOnSale) ...[
          const SizedBox(width: 8),
          Text("\$${product.originalPrice}", style: const TextStyle(color: AppColors.textSecondary, decoration: TextDecoration.lineThrough, fontSize: 12)),
        ],
      ],
    );
  }

  // --- UPDATED FILTER SIDE DRAWER WITH EXPANSION TILES ---
  Widget _buildFilterDrawer(ShoppingController controller) {
    return Drawer(
      width: 300,
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Filters", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  TextButton(
                    onPressed: controller.resetFilters, 
                    child: const Text("Reset", style: TextStyle(color: AppColors.error))
                  )
                ],
              ),
            ),
            const Divider(color: AppColors.divider),
            Expanded(
              child: ListView(
                children: [
                  // 1. Gender Filter (Dropdown)
                  Theme(
                    data: ThemeData.dark().copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                      initiallyExpanded: true,
                      textColor: AppColors.primary,
                      iconColor: AppColors.primary,
                      children: ["Men", "Women", "Juniors (Boy)", "Juniors (Girl)"].map((gender) => Obx(() => CheckboxListTile(
                        title: Text(gender, style: const TextStyle(color: AppColors.textPrimary)),
                        value: controller.selectedGenders.contains(gender),
                        activeColor: AppColors.primary,
                        checkColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        dense: true,
                        onChanged: (val) {
                          if (val == true) {
                            controller.selectedGenders.add(gender);
                          } else {
                            controller.selectedGenders.remove(gender);
                          }
                          controller.applyFilters();
                        },
                      ))).toList(),
                    ),
                  ),

                  // 2. Category Filter (Dropdown)
                  Theme(
                    data: ThemeData.dark().copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: const Text("Categories", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                      initiallyExpanded: false,
                      textColor: AppColors.primary,
                      iconColor: AppColors.primary,
                      children: controller.allFilterOptions.map((cat) => Obx(() => CheckboxListTile(
                        title: Text(cat, style: const TextStyle(color: AppColors.textPrimary)),
                        value: controller.selectedFilters.contains(cat),
                        activeColor: AppColors.primary,
                        checkColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        dense: true,
                        onChanged: (val) {
                          if (val == true) {
                            controller.selectedFilters.add(cat);
                          } else {
                            controller.selectedFilters.remove(cat);
                          }
                          controller.applyFilters();
                        },
                      ))).toList(),
                    ),
                  ),

                  // 3. Price Slider (Dropdown)
                  Theme(
                    data: ThemeData.dark().copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: const Text("Price Range", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                      initiallyExpanded: true,
                      textColor: AppColors.primary,
                      iconColor: AppColors.primary,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Obx(() => Column(
                            children: [
                              RangeSlider(
                                values: RangeValues(controller.minPrice.value, controller.maxPrice.value),
                                min: 0,
                                max: 500,
                                divisions: 10,
                                activeColor: AppColors.primary,
                                inactiveColor: Colors.grey[800],
                                labels: RangeLabels("\$${controller.minPrice.value}", "\$${controller.maxPrice.value}"),
                                onChanged: (RangeValues values) {
                                  controller.minPrice.value = values.start;
                                  controller.maxPrice.value = values.end;
                                  controller.applyFilters();
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("\$${controller.minPrice.value}", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                  Text("\$${controller.maxPrice.value}", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                ],
                              )
                            ],
                          )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.all(15)),
                  child: const Text("Apply Filters", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}