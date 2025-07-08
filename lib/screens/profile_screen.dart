import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../providers/nail_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/nail_card.dart';
import '../widgets/user_nail_card.dart';
import '../widgets/share_options_modal.dart';
import '../screens/settings_screen.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onNavigateToHome;

  const ProfileScreen({super.key, this.onNavigateToHome});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          backgroundColor: AppConstants.backgroundGray,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 200,
                  backgroundColor: AppConstants.primaryPink,
                  foregroundColor: Colors.white,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildProfileHeader(userProvider),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsScreen()),
                        );
                      },
                    ),
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Row(
                            children: [
                              Icon(Icons.edit, color: AppConstants.primaryPink),
                              SizedBox(width: 8),
                              Text('Edit Profile'),
                            ],
                          ),
                          onTap: () => _showEditProfileDialog(userProvider),
                        ),
                        PopupMenuItem(
                          child: const Row(
                            children: [
                              Icon(Icons.logout, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Logout'),
                            ],
                          ),
                          onTap: () => _handleLogout(userProvider),
                        ),
                      ],
                    ),
                  ],
                  bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    tabs: const [
                      Tab(text: 'My Uploads'),
                      Tab(text: 'Favorites'),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildMyUploadsTab(),
                _buildFavoritesTab(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddImageDialog,
            backgroundColor: AppConstants.primaryPink,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add_a_photo),
          ),
        );
      },
    );
  }

  Widget _buildMyUploadsTab() {
    return Consumer<NailProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppConstants.primaryPink,
            ),
          );
        }

        if (provider.userNailDesigns.isEmpty) {
          return _buildEmptyUploadsState();
        }

        return _buildUploadsGrid(provider);
      },
    );
  }

  Widget _buildEmptyUploadsState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 400),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppConstants.secondaryPink,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.photo_camera,
                  size: 60,
                  color: AppConstants.primaryPink,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No uploads yet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add your own nail photos\nto build your collection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.textLight,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _showAddImageDialog,
                icon: const Icon(Icons.add_a_photo),
                label: const Text('Add Photo'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadsGrid(NailProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16), // ✅ Üstten 24px
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: provider.userNailDesigns.length,
        itemBuilder: (context, index) {
          final userDesign = provider.userNailDesigns[index];
          return UserNailCard(
            userDesign: userDesign,
            onTap: () => _showUserDesignDetails(context, userDesign),
            onDelete: () => _deleteUserDesign(provider, userDesign.id),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesTab() {
    return Consumer<NailProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppConstants.primaryPink,
            ),
          );
        }

        if (provider.favorites.isEmpty) {
          return _buildEmptyFavoritesState();
        }

        return _buildFavoritesGrid(provider);
      },
    );
  }

  Widget _buildEmptyFavoritesState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 400),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppConstants.secondaryPink,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.favorite_border,
                  size: 60,
                  color: AppConstants.primaryPink,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No favorites yet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add designs to favorites\nto see them here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.textLight,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate back to home tab
                  if (widget.onNavigateToHome != null) {
                    widget.onNavigateToHome!();
                  }
                },
                icon: const Icon(Icons.explore),
                label: const Text('Explore Designs'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesGrid(NailProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16), // ✅ Üstten 24px
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: provider.favorites.length,
        itemBuilder: (context, index) {
          final design = provider.favorites[index];
          return NailCard(
            design: design,
            onTap: () => _showDesignDetails(context, design),
          );
        },
      ),
    );
  }

  void _showAddImageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Photo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      _showImageDetailDialog(image.path);
    }
  }

  void _showImageDetailDialog(String imagePath) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'French';
    List<String> selectedColors = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppConstants.backgroundGray,
                  ),
                  child: kIsWeb 
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo,
                            size: 24,
                            color: AppConstants.primaryPink,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Preview\nNot Available',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppConstants.textLight,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(imagePath),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: AppConstants.categories.skip(1) // Skip 'All' category
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: ['Pink', 'White', 'Red', 'Blue', 'Purple', 'Gold']
                      .map((color) => FilterChip(
                            label: Text(color),
                            selected: selectedColors.contains(color),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedColors.add(color);
                                } else {
                                  selectedColors.remove(color);
                                }
                              });
                            },
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Provider.of<NailProvider>(context, listen: false)
                      .addUserDesign(
                    title: titleController.text,
                    imagePath: imagePath,
                    category: selectedCategory,
                    colors: selectedColors.isEmpty ? ['Pink'] : selectedColors,
                    description: descriptionController.text.isEmpty
                        ? 'My nail design'
                        : descriptionController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserDesignDetails(BuildContext context, userDesign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildUserDesignDetailsSheet(userDesign),
    );
  }

  Widget _buildUserDesignDetailsSheet(userDesign) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            gradient: AppConstants.cardGradient,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: AppConstants.floatingShadow,
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppConstants.textLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image - more compact
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: kIsWeb 
                            ? Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppConstants.backgroundGray,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo,
                                      size: 60,
                                      color: AppConstants.primaryPink,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Image Preview Not Available on Web',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppConstants.textLight,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Image.file(
                                File(userDesign.imagePath),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Title
                      Text(
                        userDesign.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppConstants.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Category
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: AppConstants.primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          userDesign.category,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Description - compact
                      Text(
                        userDesign.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppConstants.textLight,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      
                      // Details in cards (matching home screen style)
                      _buildDetailCard('Colors', userDesign.colors.join(', '), Icons.palette),
                      _buildDetailCard('Likes', '0', Icons.favorite),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppConstants.primaryPink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppConstants.primaryPink,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDesignDetails(BuildContext context, design) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              gradient: AppConstants.cardGradient,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: AppConstants.floatingShadow,
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppConstants.textLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image - more compact
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              design.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Title with action buttons
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                design.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppConstants.textDark,
                                ),
                              ),
                            ),
                            // Share button
                            Container(
                              decoration: BoxDecoration(
                                gradient: AppConstants.primaryGradient,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: AppConstants.buttonShadow,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showShareModal(context, design);
                                },
                                icon: const Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Favorite button
                            Container(
                              decoration: BoxDecoration(
                                gradient: design.isFavorite 
                                    ? const LinearGradient(
                                        colors: [Colors.red, Colors.redAccent],
                                      )
                                    : AppConstants.primaryGradient,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: AppConstants.buttonShadow,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Provider.of<NailProvider>(context, listen: false)
                                      .toggleFavorite(design.id);
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  design.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Category
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: AppConstants.primaryGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            design.category,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Description - compact
                        Text(
                          design.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppConstants.textLight,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        
                        // Details in cards
                        _buildDetailCard('Colors', design.colors.join(', '), Icons.palette),
                        _buildDetailCard('Likes', '${design.likes}', Icons.favorite),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _deleteUserDesign(NailProvider provider, String designId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Photo'),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteUserDesign(designId);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showShareModal(BuildContext context, design) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareOptionsModal(design: design),
    );
  }

  Widget _buildProfileHeader(UserProvider userProvider) {
    final user = userProvider.currentUser;
    if (user == null) return Container();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: const BoxDecoration(
        gradient: AppConstants.primaryGradient,
      ),
      child: Row(
        children: [
          // Profile Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: user.hasProfileImage
              ? ClipOval(
                  child: kIsWeb 
                    ? const Icon(Icons.person, size: 50, color: AppConstants.primaryPink)
                    : Image.file(
                        File(user.profileImagePath!),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                )
              : Text(
                  user.initials,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppConstants.primaryPink,
                  ),
                ),
          ),
          const SizedBox(width: 20),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatItem('Uploads', '${user.uploadCount}'),
                    const SizedBox(width: 20),
                    _buildStatItem('Favorites', '${user.favoriteCount}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  void _showEditProfileDialog(UserProvider userProvider) {
    final user = userProvider.currentUser;
    if (user == null) return;

    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty && 
                  emailController.text.trim().isNotEmpty) {
                
                final navigator = Navigator.of(context);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                
                final success = await userProvider.updateProfile(
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                );
                
                if (mounted) {
                  navigator.pop();
                  if (success) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Failed to update profile'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _handleLogout(UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              navigator.pop();
              await userProvider.logout();
              if (mounted) {
                navigator.pushReplacementNamed('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
} 