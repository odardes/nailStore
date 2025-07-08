import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/nail_design.dart';
import '../providers/nail_provider.dart';
import '../widgets/animated_heart.dart';
import '../utils/constants.dart';

class NailCard extends StatelessWidget {
  final NailDesign design;
  final VoidCallback? onTap;

  const NailCard({
    super.key,
    required this.design,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppConstants.cardGradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: AppConstants.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildImage(),
              Flexible(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 1.5, // Compact ratio (3:2) for optimal grid layout
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: CachedNetworkImage(
              imageUrl: design.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover, // Cover for perfect fit without gaps
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
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Resim yüklenemedi',
                      style: TextStyle(
                        color: AppConstants.textLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Consumer<NailProvider>(
              builder: (context, provider, child) {
                return FloatingHearts(
                  isActive: design.isFavorite, // Animation triggers when this becomes true
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AnimatedHeart(
                      isFavorite: design.isFavorite,
                      onTap: () => provider.toggleFavorite(design.id),
                      size: 20,
                      activeColor: Colors.red,
                      inactiveColor: AppConstants.textLight,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getDifficultyColor(design.difficulty).withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                design.difficulty,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      constraints: const BoxConstraints(minHeight: 80), // Minimum height guarantee
      padding: const EdgeInsets.all(8), // Reduced padding 12->8
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            design.title,
            style: const TextStyle(
              fontSize: 13, // Reduced 14->13
              fontWeight: FontWeight.w600,
              color: AppConstants.textDark,
              height: 1.2, // Tighter line height
            ),
            maxLines: 1, // Single line to save space
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2), // Reduced 4->2
          Text(
            design.category,
            style: const TextStyle(
              fontSize: 10, // Reduced 11->10
              color: AppConstants.primaryPink,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          _buildColorsAndLikes(),
        ],
      ),
    );
  }


  Widget _buildColorsAndLikes() {
    return Row(
      children: [
        const Text(
          'Colors: ',
          style: TextStyle(
            fontSize: 11,
            color: AppConstants.textLight,
          ),
        ),
        Expanded(
          child: Text(
            design.colors.join(', '),
            style: const TextStyle(
              fontSize: 11,
              color: AppConstants.textDark,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 12,
            ),
            const SizedBox(width: 4),
            Text(
              '${design.likes}',
              style: const TextStyle(
                fontSize: 11,
                color: AppConstants.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Kolay':
        return Colors.green;
      case 'Orta':
        return Colors.orange;
      case 'Zor':
        return Colors.red;
      default:
        return AppConstants.textLight;
    }
  }


} 