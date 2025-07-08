import 'package:flutter/material.dart';

// Custom page route with slide transition
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final SlideDirection direction;
  final Duration duration;

  SlidePageRoute({
    required this.page,
    this.direction = SlideDirection.rightToLeft,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: direction.beginOffset,
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          },
        );
}



enum SlideDirection {
  rightToLeft,
  leftToRight,
  topToBottom,
  bottomToTop,
}

extension SlideDirectionExtension on SlideDirection {
  Offset get beginOffset {
    switch (this) {
      case SlideDirection.rightToLeft:
        return const Offset(1.0, 0.0);
      case SlideDirection.leftToRight:
        return const Offset(-1.0, 0.0);
      case SlideDirection.topToBottom:
        return const Offset(0.0, -1.0);
      case SlideDirection.bottomToTop:
        return const Offset(0.0, 1.0);
    }
  }
}

// Animated card entrance widget
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;

  const AnimatedCard({
    super.key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 100),
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuart,
      ),
    );
    
    // Start animation with delay based on index
    Future.delayed(
      Duration(milliseconds: widget.index * widget.delay.inMilliseconds),
      () {
        if (mounted) {
          _controller.forward();
        }
      },
    );
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
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

// Bounce animation widget
class BounceAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onTap;

  const BounceAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 150),
    this.onTap,
  });

  @override
  State<BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onTap?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
} 