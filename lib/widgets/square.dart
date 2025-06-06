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
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.yellow.withOpacity(0.5) : color,
          border: Border.all(color: Colors.black12),
        ),
        child: Center(
          child: Text(
            display,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
