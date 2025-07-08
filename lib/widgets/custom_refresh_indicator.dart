import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? backgroundColor;
  final Color? color;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.backgroundColor,
    this.color,
  });

  @override
  State<CustomRefreshIndicator> createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _animationController.repeat();
        await widget.onRefresh();
        _animationController.stop();
        _animationController.reset();
      },
      backgroundColor: widget.backgroundColor ?? Colors.white,
      color: widget.color ?? AppConstants.primaryPink,
      strokeWidth: 3.0,
      displacement: 50.0,
      child: widget.child,
    );
  }
}

// Floating refresh button
class FloatingRefreshButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isVisible;

  const FloatingRefreshButton({
    super.key,
    required this.onPressed,
    this.isVisible = true,
  });

  @override
  State<FloatingRefreshButton> createState() => _FloatingRefreshButtonState();
}

class _FloatingRefreshButtonState extends State<FloatingRefreshButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(FloatingRefreshButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse().then((_) {
        widget.onPressed();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159,
            child: FloatingActionButton(
              onPressed: _handleTap,
              backgroundColor: AppConstants.primaryPink,
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Animated loading dots
class LoadingDots extends StatefulWidget {
  final Color? color;
  final double size;

  const LoadingDots({
    super.key,
    this.color,
    this.size = 8.0,
  });

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    
    _controllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );
    
    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();
    
    _startAnimation();
  }

  void _startAnimation() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: (widget.color ?? AppConstants.primaryPink)
                    .withOpacity(_animations[index].value),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}

// Refresh animation widget
class RefreshAnimationWidget extends StatefulWidget {
  final bool isRefreshing;
  final Widget child;

  const RefreshAnimationWidget({
    super.key,
    required this.isRefreshing,
    required this.child,
  });

  @override
  State<RefreshAnimationWidget> createState() => _RefreshAnimationWidgetState();
}

class _RefreshAnimationWidgetState extends State<RefreshAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 0.1),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(RefreshAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isRefreshing != oldWidget.isRefreshing) {
      if (widget.isRefreshing) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
} 