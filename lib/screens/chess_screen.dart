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
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        title: const Text(
          'Flutter Chess',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF16213e),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GetBuilder<ChessController>(
                      builder: (controller) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 64,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                              ),
                          itemBuilder: (context, index) {
                            final file = 'abcdefgh'[index % 8];
                            final rank = (8 - index ~/ 8).toString();
                            final square = '$file$rank';
                            return Obx(() {
                              final pieceSymbol = controller.getPieceSymbol(
                                square,
                              );
                              final isSelected =
                                  controller.selectedSquare.value == square;
                              return Square(
                                color:
                                    (index + index ~/ 8) % 2 == 0
                                        ? const Color(0xFFF0D9B5)
                                        : const Color(0xFFB58863),
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
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0f3460),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF533483).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Obx(
                () => Text(
                  controller.gameStatus.value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
