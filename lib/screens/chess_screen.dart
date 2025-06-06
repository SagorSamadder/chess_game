import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chess_controller.dart';
import '../widgets/square.dart';

class ChessScreen extends StatelessWidget {
  final ChessController controller = Get.put(ChessController());

  ChessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Chess'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<ChessController>(
              builder: (controller) {
                return GridView.builder(
                  itemCount: 64,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                  ),
                  itemBuilder: (context, index) {
                    final file = 'abcdefgh'[index % 8];
                    final rank = (8 - index ~/ 8).toString();
                    final square = '$file$rank';
                    return Obx(() {
                      final pieceSymbol = controller.getPieceSymbol(square);
                      final isSelected =
                          controller.selectedSquare.value == square;
                      return Square(
                        color:
                            (index + index ~/ 8) % 2 == 0
                                ? Colors.white
                                : Colors.grey,
                        pieceSymbol: pieceSymbol,
                        onTap: () => controller.onSquareTapped(square),
                        isSelected: isSelected,
                      );
                    });
                  },
                );
              },
            ),
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                controller.gameStatus.value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
