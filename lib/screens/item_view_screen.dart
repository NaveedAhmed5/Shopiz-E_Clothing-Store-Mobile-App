import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../constants.dart';
import 'wishlist_screen.dart'; // Import Wishlist Controller
import 'cart_screen.dart'; // Import Cart Controller

// --- CONTROLLER (LOGIC) ---
class ItemViewController extends GetxController {
  final Product product;
  
  final RxInt currentImageIndex = 0.obs;
  final RxString selectedSize = ''.obs;
  final RxInt selectedColorIndex = 0.obs;
  final RxInt quantity = 1.obs;

  // Review Logic
  late RxList<Review> reviews;
  final RxDouble currentRating = 0.0.obs;
  final TextEditingController reviewController = TextEditingController();
  final RxDouble userRating = 5.0.obs; // Default 5 stars
  
  // Dependency Injection
  final CartController cartController = Get.put(CartController());

  ItemViewController(this.product);

  @override
  void onInit() {
    super.onInit();
    
    // Set defaults
    if (product.sizes.isNotEmpty) {
      selectedSize.value = product.sizes.first;
    }
    if (product.colors.isNotEmpty) {
      selectedColorIndex.value = 0;
    }

    // Initialize Reviews
    reviews = (product.reviews).obs; 
    currentRating.value = product.rating;
    
    // If no reviews but we have a rating, we can just respect the base rating.
    if (reviews.isNotEmpty) {
      _calculateAverageRating();
    }
  }

  void _calculateAverageRating() {
    if (reviews.isEmpty) return;
    double total = reviews.fold(0, (sum, item) => sum + item.rating);
    currentRating.value = total / reviews.length;
  }
  
  void incrementQuantity() {
    quantity.value++;
  }
  
  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void submitReview() {
    if (reviewController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please write a comment", backgroundColor: AppColors.error, colorText: Colors.white);
      return;
    }

    final newReview = Review(
      id: DateTime.now().toString(),
      userName: "You", // Hardcoded for now
      rating: userRating.value,
      comment: reviewController.text.trim(),
      date: DateTime.now(),
    );

    reviews.insert(0, newReview); // Add to top
    _calculateAverageRating();
    
    reviewController.clear();
    userRating.value = 5.0;
    Get.back(); // Close dialog/bottom sheet if open
    Get.snackbar("Success", "Review submitted!", backgroundColor: AppColors.success, colorText: Colors.white);
  }

  void addToCart() {
    if (product.sizes.isNotEmpty && selectedSize.value.isEmpty) {
      Get.snackbar("Select Size", "Please select a size first", backgroundColor: AppColors.error, colorText: Colors.white);
      return;
    }
    
    cartController.addToCart(
      product,
      selectedSize.value,
      selectedColorIndex.value,
      quantity.value,
    );
     // Optional: Feedback is handled in controller, but we can dismiss or navigate here if needed
  }
  
  void buyNow() {
    addToCart();
    Get.to(() => const CartScreen()); 
  }
}

// --- UI SCREEN ---
class ItemViewScreen extends StatelessWidget {
  final Product product;
  
  const ItemViewScreen({super.key, required this.product});
  
  @override
  Widget build(BuildContext context) {
    final ItemViewController controller = Get.put(ItemViewController(product));
    final WishlistController wishlistController = Get.put(WishlistController()); 
    
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: const Text("Details", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.primary),
            onPressed: () {},
          ),
          Obx(() => IconButton(
            icon: Icon(
              wishlistController.isWishlisted(product) ? Icons.favorite : Icons.favorite_border,
              color: AppColors.primary,
            ),
            onPressed: () => wishlistController.toggleWishlist(product),
          )),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageCarousel(controller),
                  const SizedBox(height: 20),
                  _buildProductInfo(controller),
                  const SizedBox(height: 20),
                  _buildSizeSelector(controller),
                  const SizedBox(height: 20),
                  _buildColorSelector(controller),
                  const SizedBox(height: 20),
                  _buildQuantitySelector(controller),
                  const SizedBox(height: 20),
                  _buildProductDetails(controller),
                  const SizedBox(height: 20),
                  _buildDescription(controller),
                   const SizedBox(height: 20),
                  _buildReviewsSection(context, controller),
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ),
          _buildBottomButtons(controller),
        ],
      ),
    );
  }
  
  Widget _buildImageCarousel(ItemViewController controller) {
    return Stack(
      children: [
        SizedBox(
          height: 400,
          child: PageView.builder(
            itemCount: product.imageUrls.length,
            onPageChanged: (index) => controller.currentImageIndex.value = index,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.grey[100],
                child: product.imageUrls[index].startsWith('http')
                    ? Image.network(product.imageUrls[index], fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.error))
                    : Image.asset(product.imageUrls[index], fit: BoxFit.cover, errorBuilder: (c,e,s) => const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey))),
              );
            },
          ),
        ),
        
        if (product.isOnSale)
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '-${product.discountPercent}% OFF',
                style: const TextStyle(
                  color: AppColors.primary, 
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        
        if (product.imageUrls.length > 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                product.imageUrls.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: controller.currentImageIndex.value == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: controller.currentImageIndex.value == index
                        ? AppColors.secondary 
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            )),
          ),
      ],
    );
  }
  
  Widget _buildProductInfo(ItemViewController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary, 
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.secondary, size: 20), 
              const SizedBox(width: 4),
              Obx(() => Text(
                controller.currentRating.value.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              )),
              const SizedBox(width: 4),
              Obx(() => Text(
                '(${controller.reviews.length} reviews)', 
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              if (product.isOnSale) ...[
                const SizedBox(width: 12),
                Text(
                  '\$${product.originalPrice!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSizeSelector(ItemViewController controller) {
    if (product.sizes.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Size',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: product.sizes.map((size) {
              final isSelected = controller.selectedSize.value == size;
              return GestureDetector(
                onTap: () => controller.selectedSize.value = size,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 4)] : [],
                  ),
                  child: Text(
                    size,
                    style: TextStyle(
                      color: isSelected ? AppColors.secondary : AppColors.textPrimary, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }
  
  Widget _buildColorSelector(ItemViewController controller) {
    if (product.colors.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Color',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(product.colors.length, (index) {
              final isSelected = controller.selectedColorIndex.value == index;
              return GestureDetector(
                onTap: () => controller.selectedColorIndex.value = index,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: product.colors[index],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.secondary : Colors.grey[300]!, 
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 24)
                      : null,
                ),
              );
            }),
          )),
        ],
      ),
    );
  }
  
  Widget _buildQuantitySelector(ItemViewController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quantity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.divider),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: controller.decrementQuantity,
                      color: AppColors.primary,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        controller.quantity.value.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: controller.incrementQuantity,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
  
  Widget _buildProductDetails(ItemViewController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Category', product.category),
          _buildDetailRow('Sub-Category', product.subCategory),
          _buildDetailRow('Gender', product.gender),
          _buildDetailRow('Season', product.season),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDescription(ItemViewController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context, ItemViewController controller) {
     return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 20),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               const Text(
                 'Reviews',
                 style: TextStyle(
                   fontSize: 18,
                   fontWeight: FontWeight.bold,
                   color: AppColors.textPrimary,
                 ),
               ),
               TextButton.icon(
                 onPressed: () => _showAddReviewDialog(context, controller), 
                 icon: const Icon(Icons.rate_review, color: AppColors.primary, size: 20),
                 label: const Text("Write a Review", style: TextStyle(color: AppColors.primary)),
               ),
             ],
           ),
           const SizedBox(height: 10),
           Obx(() {
             if (controller.reviews.isEmpty) {
               return const Padding(
                 padding: EdgeInsets.symmetric(vertical: 20),
                 child: Text("No reviews yet. Be the first to review!", style: TextStyle(color: Colors.grey)),
               );
             }
             return Column(
               children: controller.reviews.map((review) => Container(
                 margin: const EdgeInsets.only(bottom: 12), 
                 padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(
                   color: Colors.grey[50], 
                   borderRadius: BorderRadius.circular(10),
                   border: Border.all(color: Colors.grey.withOpacity(0.2)),
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                         Text(
                             "${review.date.day}/${review.date.month}/${review.date.year}", 
                             style: const TextStyle(fontSize: 12, color: Colors.grey)
                         ),
                       ],
                     ),
                     const SizedBox(height: 4),
                     Row(
                       children: List.generate(5, (index) {
                         return Icon(
                           index < review.rating ? Icons.star : Icons.star_border,
                           size: 16,
                           color: AppColors.secondary,
                         );
                       }),
                     ),
                     const SizedBox(height: 8),
                     Text(review.comment, style: const TextStyle(color: AppColors.textPrimary)),
                   ],
                 ),
               )).toList(),
             );
           }),
         ],
       ),
     );
  }

  void _showAddReviewDialog(BuildContext context, ItemViewController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Write a Review", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              
              const Text("Your Rating", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              Center(
                child: Obx(() => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < controller.userRating.value ? Icons.star : Icons.star_border,
                        color: AppColors.secondary,
                        size: 32,
                      ),
                      onPressed: () => controller.userRating.value = index + 1.0,
                    );
                  }),
                )),
              ),
              
              const SizedBox(height: 20),
              TextField(
                controller: controller.reviewController,
                style: const TextStyle(color: Colors.black), 
                decoration: const InputDecoration(
                  labelText: "Your Comment",
                  labelStyle: TextStyle(color: Colors.grey),
                  hintText: "Tell us what you liked...",
                  hintStyle: TextStyle(color: Colors.black38),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Submit Review", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildBottomButtons(ItemViewController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: controller.addToCart,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.primary, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: controller.buyNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(
                  color: AppColors.secondary, 
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
