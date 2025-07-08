import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gal/gal.dart';
import 'package:file_saver/file_saver.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import '../models/nail_design.dart';
import '../utils/constants.dart';

class ShareOptionsModal extends StatelessWidget {
  final NailDesign design;

  const ShareOptionsModal({
    super.key,
    required this.design,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  Icons.share,
                  color: AppConstants.primaryPink,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Share Design',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppConstants.textDark,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Share options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Design preview
                _buildDesignPreview(),
                const SizedBox(height: 20),
                
                // Share options
                _buildShareOptions(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignPreview() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppConstants.cardShadow,
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: design.imageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppConstants.backgroundGray,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppConstants.primaryPink,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Design info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  design.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  design.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppConstants.primaryPink,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${design.likes} likes',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppConstants.textLight,
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
  }

  Widget _buildShareOptions(BuildContext context) {
    return Row(
      children: [
        // Save to Device
        Expanded(
          child: GestureDetector(
            onTap: () => _saveToGallery(context),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download,
                    color: AppConstants.primaryPink,
                    size: 28,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Cihaza Kaydet',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // WhatsApp Share
        Expanded(
          child: GestureDetector(
            onTap: () => _shareToWhatsApp(context),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message,
                    color: Color(0xFF25D366),
                    size: 28,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'WhatsApp Gönder',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _saveToGallery(BuildContext context) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    navigator.pop();
    
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: AppConstants.primaryPink,
          ),
        ),
      );

      // Download image
      final response = await http.get(Uri.parse(design.imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        
        // Save based on platform
        if (kIsWeb) {
          // Web platform - use file_saver
          final fileName = '${design.title.replaceAll(' ', '_')}_nail_design.jpg';
          await FileSaver.instance.saveFile(
            name: fileName,
            bytes: bytes,
            ext: 'jpg',
            mimeType: MimeType.jpeg,
          );
        } else {
          // Mobile platform - use gal
          await Gal.putImageBytes(bytes);
        }
        
        if (context.mounted) {
          Navigator.pop(context); // Close loading dialog
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Resim başarıyla kaydedildi!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        throw Exception('Failed to download image - Status: ${response.statusCode}');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Resim kaydedilemedi. Lütfen tekrar deneyin.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _shareToWhatsApp(BuildContext context) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    navigator.pop();
    
    try {
      final shareText = _buildShareText();
      final Uri whatsappUri = Uri.parse(
        'https://wa.me/?text=${Uri.encodeComponent(shareText)}'
      );
      
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to regular share
        await Share.share(shareText);
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Paylaşım başarısız. Lütfen tekrar deneyin.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _buildShareText() {
    return 'Bu güzel nail tasarımına göz atın: "${design.title}"\n\n'
           '✨ Kategori: ${design.category}\n'
           '🎨 Renkler: ${design.colors.join(', ')}\n'
           '💕 ${design.likes} beğeni\n\n'
           '${design.description}\n\n'
           'Daha fazla ilham için Nail Ideas uygulamasını indirin! 💅';
  }
} 