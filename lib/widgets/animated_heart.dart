import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AnimatedHeart extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const AnimatedHeart({
    super.key,
    required this.isFavorite,
    required this.onTap,
    this.size = 24.0,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _colorController;
  late Animation<double> _bounceAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Bounce animation controller
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    // Color animation controller
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Bounce animation - creates a scale bounce effect
    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.4,
    ).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.elasticOut,
      ),
    );
    
    // Scale animation for tap feedback
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeInOut),
      ),
    );
    
    // Color animation
    _colorAnimation = ColorTween(
      begin: widget.inactiveColor ?? AppConstants.textLight,
      end: widget.activeColor ?? AppConstants.primaryPink,
    ).animate(
      CurvedAnimation(
        parent: _colorController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Set initial state
    if (widget.isFavorite) {
      _colorController.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedHeart oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isFavorite != oldWidget.isFavorite) {
      if (widget.isFavorite) {
        _colorController.forward();
        _bounceController.forward().then((_) {
          _bounceController.reverse();
        });
      } else {
        _colorController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_bounceAnimation, _colorAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value * _bounceAnimation.value,
            child: Icon(
              widget.isFavorite ? Icons.favorite : Icons.favorite_border,
              size: widget.size,
              color: _colorAnimation.value,
            ),
          );
        },
      ),
    );
  }
}

// Hearts floating animation widget for extra delight
class FloatingHearts extends StatefulWidget {
  final bool isActive;
  final Widget child;

  const FloatingHearts({
    super.key,
    required this.isActive,
    required this.child,
  });

  @override
  State<FloatingHearts> createState() => _FloatingHeartsState();
}

class _FloatingHeartsState extends State<FloatingHearts>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<AnimationController> _heartControllers;
  late List<Animation<Offset>> _heartAnimations;
  late List<Animation<double>> _heartOpacities;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _heartControllers = List.generate(
      5,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800 + (index * 100)),
        vsync: this,
      ),
    );
    
    _heartAnimations = _heartControllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, 0),
        end: Offset(
          (controller.hashCode % 100 - 50) / 100,
          -2.0,
        ),
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ),
      );
    }).toList();
    
    _heartOpacities = _heartControllers.map((controller) {
      return Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
        ),
      );
    }).toList();
  }

  @override
  void didUpdateWidget(FloatingHearts oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Start animation when becoming active (not favorited -> favorited)
    if (widget.isActive && !oldWidget.isActive) {
      _isAnimating = true;
      _startFloatingHearts();
    }
  }

  void _startFloatingHearts() {
    int completedAnimations = 0;
    for (int i = 0; i < _heartControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _heartControllers[i].forward().then((_) {
            _heartControllers[i].reset();
            completedAnimations++;
            
            // When all animations are done, stop showing hearts
            if (completedAnimations >= _heartControllers.length) {
              _isAnimating = false;
              if (mounted) {
                setState(() {});
              }
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in _heartControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        // Only show floating hearts when actively animating
        if (_isAnimating)
          ...List.generate(_heartControllers.length, (index) {
            return AnimatedBuilder(
              animation: _heartControllers[index],
              builder: (context, child) {
                return Transform.translate(
                  offset: _heartAnimations[index].value * 50,
                  child: Opacity(
                    opacity: _heartOpacities[index].value,
                    child: const Icon(
                      Icons.favorite,
                      color: AppConstants.primaryPink,
                      size: 16,
                    ),
                  ),
                );
              },
            );
          }),
      ],
    );
  }
} 