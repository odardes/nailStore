import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AdvancedSearchModal extends StatefulWidget {
  final List<String> selectedCategories;
  final List<String> selectedColors;
  final String selectedSortOption;
  final Function(List<String>, List<String>, String) onFiltersApplied;

  const AdvancedSearchModal({
    super.key,
    required this.selectedCategories,
    required this.selectedColors,
    required this.selectedSortOption,
    required this.onFiltersApplied,
  });

  @override
  State<AdvancedSearchModal> createState() => _AdvancedSearchModalState();
}

class _AdvancedSearchModalState extends State<AdvancedSearchModal> {
  late List<String> _tempSelectedCategories;
  late List<String> _tempSelectedColors;
  late String _tempSelectedSortOption;

  @override
  void initState() {
    super.initState();
    _tempSelectedCategories = List.from(widget.selectedCategories);
    _tempSelectedColors = List.from(widget.selectedColors);
    _tempSelectedSortOption = widget.selectedSortOption;
  }



  Widget _buildSortSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sort By',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppConstants.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.sortOptions.map((option) {
            final isSelected = _tempSelectedSortOption == option;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _tempSelectedSortOption = option;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppConstants.primaryPink : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppConstants.primaryPink : AppConstants.textLight,
                    width: 1,
                  ),
                  boxShadow: isSelected ? AppConstants.buttonShadow : [],
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppConstants.textDark,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppConstants.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.categories.skip(1).map((category) { // Skip 'All'
            final isSelected = _tempSelectedCategories.contains(category);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _tempSelectedCategories.remove(category);
                  } else {
                    _tempSelectedCategories.add(category);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppConstants.primaryPink : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppConstants.primaryPink : AppConstants.textLight,
                    width: 1,
                  ),
                  boxShadow: isSelected ? AppConstants.buttonShadow : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppConstants.textDark,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Colors',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppConstants.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.availableColors.map((color) {
            final isSelected = _tempSelectedColors.contains(color);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _tempSelectedColors.remove(color);
                  } else {
                    _tempSelectedColors.add(color);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppConstants.primaryPink : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppConstants.primaryPink : AppConstants.textLight,
                    width: 1,
                  ),
                  boxShadow: isSelected ? AppConstants.buttonShadow : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _getColorFromName(color),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.white : AppConstants.textLight,
                          width: 1,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      color,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppConstants.textDark,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'pink':
        return Colors.pink;
      case 'white':
        return Colors.grey.shade100;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      case 'gold':
        return Colors.amber;
      case 'black':
        return Colors.black;
      case 'silver':
        return Colors.grey;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'nude':
        return Colors.brown.shade200;
      default:
        return Colors.grey;
    }
  }

  void _clearAllFilters() {
    setState(() {
      _tempSelectedCategories.clear();
      _tempSelectedColors.clear();
      _tempSelectedSortOption = 'Most Popular';
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(
      _tempSelectedCategories,
      _tempSelectedColors,
      _tempSelectedSortOption,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppConstants.cardGradient,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: AppConstants.floatingShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.filter_list,
                    color: AppConstants.primaryPink,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Advanced Search',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.textDark,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        color: AppConstants.primaryPink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1, color: AppConstants.textLight),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSortSection(),
                    const SizedBox(height: 24),
                    _buildCategorySection(),
                    const SizedBox(height: 24),
                    _buildColorSection(),
                    const SizedBox(height: 80), // Space for floating button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: AppConstants.primaryGradient,
          borderRadius: BorderRadius.circular(25),
          boxShadow: AppConstants.buttonShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _applyFilters,
            borderRadius: BorderRadius.circular(25),
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                'Apply Filters (${_getFilterCount()})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  int _getFilterCount() {
    int count = 0;
    if (_tempSelectedCategories.isNotEmpty) count++;
    if (_tempSelectedColors.isNotEmpty) count++;
    if (_tempSelectedSortOption != 'Most Popular') count++;
    return count;
  }
} 