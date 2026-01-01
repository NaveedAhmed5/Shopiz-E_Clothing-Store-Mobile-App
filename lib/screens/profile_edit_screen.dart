import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';

// --- EDIT PROFILE SCREEN ---
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'profile_screen.dart'; // import to access ProfileController

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Access the global controller
  final ProfileController profileController = Get.find<ProfileController>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    // Initialize with current values
    nameController = TextEditingController(text: profileController.userName.value);
    emailController = TextEditingController(text: profileController.userEmail.value);
    phoneController = TextEditingController(text: profileController.userPhone.value);
    _selectedImage = profileController.profileImage.value;
  }
  
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Camera', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () {
                _getImage(ImageSource.camera);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Gallery', style: TextStyle(color: AppColors.textPrimary)),
              onTap: () {
                _getImage(ImageSource.gallery);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.secondary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueAccent, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImage != null 
                        ? FileImage(_selectedImage!) 
                        : const AssetImage("assets/images/profile_pic.jpg") as ImageProvider,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField("Full Name", nameController, Icons.person),
            const SizedBox(height: 20),
            _buildTextField("Email Address", emailController, Icons.email),
            const SizedBox(height: 20),
            _buildTextField("Phone Number", phoneController, Icons.phone),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Save changes using controller
                  profileController.updateProfile(
                    nameController.text.trim(),
                    emailController.text.trim(),
                    phoneController.text.trim(),
                    _selectedImage
                  );
                  Get.back();
                  Get.snackbar("Success", "Profile Updated Successfully!", backgroundColor: AppColors.success, colorText: Colors.white);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Save Changes", style: TextStyle(color: AppColors.secondary, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.textSecondary),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondary)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
