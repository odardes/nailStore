import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../models/nail_design.dart';
import '../utils/constants.dart';

class UserNailCard extends StatelessWidget {
  final UserNailDesign userDesign;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const UserNailCard({
    super.key,
    required this.userDesign,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: _buildCardContent(),
      ),
    );
  }

  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageSection(),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userDesign.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                userDesign.category,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppConstants.primaryPink,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              _buildColorsAndLikes(),
              const SizedBox(height: 6),
              Text(
                '${userDesign.createdAt.day}/${userDesign.createdAt.month}/${userDesign.createdAt.year}',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppConstants.textLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return AspectRatio(
      aspectRatio: 1.5, // Same compact ratio as NailCard (3:2)
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: kIsWeb 
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppConstants.backgroundGray,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo,
                        size: 40,
                        color: AppConstants.primaryPink,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Image Preview\nNot Available on Web',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppConstants.textLight,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              : Image.file(
                  File(userDesign.imagePath),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: AppConstants.backgroundGray,
                      child: const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: AppConstants.textLight,
                      ),
                    );
                  },
                ),
          ),
          if (onDelete != null)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.primaryPink.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'My Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
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
            userDesign.colors.join(', '),
            style: const TextStyle(
              fontSize: 11,
              color: AppConstants.textDark,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              color: Colors.red,
              size: 12,
            ),
            SizedBox(width: 4),
            Text(
              '0',
              style: TextStyle(
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
} 