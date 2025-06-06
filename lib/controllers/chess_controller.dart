import 'package:chess/chess.dart' as ch;
import 'package:get/get.dart';

class ChessController extends GetxController {
  final ch.Chess _game = ch.Chess();
  final RxList<ch.Piece?> board = List<ch.Piece?>.filled(64, null).obs;
  var selectedSquare = Rxn<String>();
  var inCheck = false.obs;
  var gameOver = false.obs;
  var currentTurn = ch.Color.WHITE.obs;
  var gameStatus = ''.obs; // Reactive game status variable

  @override
  void onInit() {
    super.onInit();
    loadBoard();
  }

  void loadBoard() {
    // Convert the 2D board representation to a 1D list for GridView
    final newBoard = List<ch.Piece?>.filled(64, null);
    for (var rank = 0; rank < 8; rank++) {
      for (var file = 0; file < 8; file++) {
        final square =
            '${String.fromCharCode('a'.codeUnitAt(0) + file)}${8 - rank}';
        final piece = _game.get(square);
        newBoard[rank * 8 + file] = piece;
      }
    }
    board.assignAll(newBoard); // Use assignAll for reactive update
    inCheck.value = _game.in_check;
    gameOver.value = _game.game_over;
    currentTurn.value = _game.turn; // Update turn reactively
    // Assign game status to the reactive variable
    gameStatus.value =
        _game.in_checkmate
            ? "${_game.turn == ch.Color.WHITE ? 'Black' : 'White'} wins by checkmate!"
            : _game.in_stalemate
            ? "Game ends in stalemate!"
            : _game.in_draw
            ? "Game ends in a draw!"
            : _game.in_check
            ? "Check!"
            : "${_game.turn == ch.Color.WHITE ? 'White' : 'Black'} to move";
  }

  void onSquareTapped(String square) {
    try {
      final piece = _game.get(square);
      if (selectedSquare.value == null) {
        // Select a piece if it belongs to the current player
        if (piece != null && piece.color == _game.turn) {
          selectedSquare.value = square;
          update(); // Trigger UI update
        }
      } else {
        // Attempt to make a move
        final move = {'from': selectedSquare.value!, 'to': square};
        final isValidMove = _game.move(move);
        if (isValidMove) {
          loadBoard();
        }
        selectedSquare.value = null;
        update(); // Trigger UI update
      }
    } catch (e) {
      print("Error processing move: $square | Error: $e");
      selectedSquare.value = null;
      update(); // Trigger UI update
    }
  }

  String? getPieceSymbol(String square) {
    final piece = _game.get(square);
    if (piece == null) return null;
    return "${piece.color == ch.Color.WHITE ? 'w' : 'b'}${piece.type}";
  }

  bool isInCheck() => _game.in_check;
  bool isGameOver() => _game.game_over;
}
