import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/nail_provider.dart';
import '../widgets/nail_card.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/animated_heart.dart';
import '../widgets/page_transitions.dart';
import '../widgets/custom_refresh_indicator.dart';
import '../widgets/advanced_search_modal.dart';
import '../widgets/share_options_modal.dart';

import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToProfile;
  
  const HomeScreen({
    super.key,
    this.onNavigateToProfile,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Advanced search filters
  List<String> _selectedCategories = [];
  List<String> _selectedColors = [];
  String _selectedSortOption = 'Most Popular';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppConstants.backgroundGradient,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
        title: const Text(AppConstants.appName),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppConstants.primaryGradient,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          Consumer<NailProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: AnimatedHeart(
                      isFavorite: provider.favorites.isNotEmpty,
                      onTap: () {
                        // Navigate to profile screen
                        widget.onNavigateToProfile?.call();
                      },
                      size: 24,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white70,
                    ),
                    onPressed: () {
                      widget.onNavigateToProfile?.call();
                    },
                  ),
                  if (provider.favorites.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${provider.favorites.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
          body: Consumer<NailProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const SkeletonGrid(itemCount: 6);
              }

              return Column(
                children: [
                  _buildSearchBar(provider),
                  if (_searchQuery.isEmpty) _buildCategoryTabs(provider),
                  Expanded(
                    child: _buildDesignGrid(provider),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(NailProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search by design, color, or category...',
          prefixIcon: const Icon(Icons.search, color: AppConstants.primaryPink),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Filter button
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.filter_list, color: AppConstants.primaryPink),
                    if (_hasActiveFilters())
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '${_getActiveFilterCount()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: _showAdvancedSearchModal,
              ),
              // Clear button
              if (_searchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, color: AppConstants.textLight),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                ),
            ],
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppConstants.textLight, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppConstants.primaryPink, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(NailProvider provider) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.categories.length,
        itemBuilder: (context, index) {
          final category = AppConstants.categories[index];
          final isSelected = provider.selectedCategory == category;
          
          return BounceAnimation(
            onTap: () => provider.changeCategory(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppConstants.primaryPink : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? AppConstants.primaryPink : AppConstants.textLight,
                  width: 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppConstants.primaryPink.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : [],
              ),
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppConstants.textDark,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 16,
                  ),
                  child: Text(category),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesignGrid(NailProvider provider) {
    // Use advanced search if filters are active
    final designs = _hasActiveFilters() || _searchQuery.isNotEmpty
        ? provider.advancedSearchDesigns(
            searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
            categories: _selectedCategories.isNotEmpty ? _selectedCategories : null,
            colors: _selectedColors.isNotEmpty ? _selectedColors : null,
            sortBy: _selectedSortOption != 'Most Popular' ? _selectedSortOption : null,
          )
        : provider.filteredDesigns;
    
    if (designs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isNotEmpty ? Icons.search_off : Icons.category_outlined,
              size: 80,
              color: AppConstants.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty 
                  ? 'No designs found for "$_searchQuery"'
                  : 'No designs found in this category',
              style: const TextStyle(
                fontSize: 18,
                color: AppConstants.textLight,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Try different keywords or check spelling',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.textLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
    }

    return CustomRefreshIndicator(
      onRefresh: provider.refreshData,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          itemCount: designs.length,
          itemBuilder: (context, index) {
            final design = designs[index];
            return AnimatedCard(
              index: index,
              delay: const Duration(milliseconds: 80),
              duration: const Duration(milliseconds: 500),
              child: BounceAnimation(
                onTap: () => _showDesignDetails(context, design),
                child: NailCard(
                  design: design,
                  onTap: () => _showDesignDetails(context, design),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDesignDetails(BuildContext context, design) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDesignDetailsSheet(design),
    );
  }

  Widget _buildDesignDetailsSheet(design) {
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
              // Handle bar
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
                      // Image - compact for modal view
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: AspectRatio(
                          aspectRatio: 3 / 2, // More compact ratio (landscape)
                          child: CachedNetworkImage(
                            imageUrl: design.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppConstants.backgroundGray,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppConstants.primaryPink,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppConstants.backgroundGray,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    color: AppConstants.textLight,
                                    size: 50,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Resim yüklenemedi',
                                    style: TextStyle(
                                      color: AppConstants.textLight,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

  // Advanced search helper methods
  bool _hasActiveFilters() {
    return _selectedCategories.isNotEmpty || 
           _selectedColors.isNotEmpty || 
           _selectedSortOption != 'Most Popular';
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_selectedCategories.isNotEmpty) count++;
    if (_selectedColors.isNotEmpty) count++;
    if (_selectedSortOption != 'Most Popular') count++;
    return count;
  }

  void _showAdvancedSearchModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return AdvancedSearchModal(
            selectedCategories: _selectedCategories,
            selectedColors: _selectedColors,
            selectedSortOption: _selectedSortOption,
            onFiltersApplied: (categories, colors, sortOption) {
              setState(() {
                _selectedCategories = categories;
                _selectedColors = colors;
                _selectedSortOption = sortOption;
              });
            },
          );
        },
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
} 