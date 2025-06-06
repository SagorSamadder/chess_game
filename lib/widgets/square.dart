import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final Color color;
  final String? pieceSymbol;
  final VoidCallback onTap;
  final bool isSelected;

  const Square({
    super.key,
    required this.color,
    required this.pieceSymbol,
    required this.onTap,
    required this.isSelected,
  });

  String get display {
    if (pieceSymbol == null) return '';
    final map = {
      'wp': '♙',
      'wr': '♖',
      'wn': '♘',
      'wb': '♗',
      'wq': '♕',
      'wk': '♔',
      'bp': '♟',
      'br': '♜',
      'bn': '♞',
      'bb': '♝',
      'bq': '♛',
      'bk': '♚',
    };
    return map[pieceSymbol!] ?? pieceSymbol!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7dd3fc).withOpacity(0.8) : color,
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: const Color(0xFF7dd3fc).withOpacity(0.6),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                  : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black.withOpacity(0.1),
              width: 0.5,
            ),
          ),
          child: Center(
            child: AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                display,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
