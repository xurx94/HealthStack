import 'package:flutter/material.dart';

class HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double? width; // CHANGED: Made width optional/nullable
  final double? height; // CHANGED: Made height optional/nullable
  final Color shadowColor;
  final double borderRadius;

  const HoverCard({
    super.key,
    required this.child,
    required this.onTap,
    this.width, // Removed the strict defaults
    this.height, // Removed the strict defaults
    this.shadowColor = Colors.blue,
    this.borderRadius = 16,
    required RoundedRectangleBorder shape,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovering
            ? (Matrix4.identity()..translate(0, -8))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: widget.shadowColor.withOpacity(0.4),
              blurRadius: _isHovering ? 20 : 8,
              offset: Offset(0, _isHovering ? 10 : 4),
            ),
          ],
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            onTap: widget.onTap,
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
