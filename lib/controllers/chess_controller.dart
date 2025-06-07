import 'package:chess/chess.dart' as ch;
import 'package:get/get.dart';

class ChessController extends GetxController {
  final ch.Chess _game = ch.Chess();
  final RxList<ch.Piece?> board = List<ch.Piece?>.filled(64, null).obs;
  var selectedSquare = Rxn<String>();
  var inCheck = false.obs;
  var gameOver = false.obs;
  var currentTurn = ch.Color.WHITE.obs;
  var gameStatus = ''.obs;
  var showModeSelection = true.obs;
  var isSinglePlayer = false.obs;
  var suggestedMoves = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBoard();
  }

  void startSinglePlayerMode() {
    isSinglePlayer.value = true;
    showModeSelection.value = false;
    resetGame();
  }

  void startTwoPlayerMode() {
    isSinglePlayer.value = false;
    showModeSelection.value = false;
    resetGame();
  }

  void resetGame() {
    _game.reset();
    loadBoard();
    suggestedMoves.clear();
    selectedSquare.value = null;
  }

  void loadBoard() {
    final newBoard = List<ch.Piece?>.filled(64, null);
    for (var rank = 0; rank < 8; rank++) {
      for (var file = 0; file < 8; file++) {
        final square =
            '${String.fromCharCode('a'.codeUnitAt(0) + file)}${8 - rank}';
        final piece = _game.get(square);
        newBoard[rank * 8 + file] = piece;
      }
    }
    board.assignAll(newBoard);
    inCheck.value = _game.in_check;
    gameOver.value = _game.game_over;
    currentTurn.value = _game.turn;
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
    if (isSinglePlayer.value &&
        _game.turn == ch.Color.BLACK &&
        !gameOver.value) {
      _makeBotMove();
    }
  }

  void _makeBotMove() {
    final moves = _game.generate_moves();
    if (moves.isNotEmpty) {
      moves.shuffle();
      final move = moves.first;
      _game.move({
        'from': move.from, // Changed from move['from'] to move.from
        'to': move.to, // Changed from move['to'] to move.to
      });
      loadBoard();
    }
  }

  void _generateMoveSuggestions(String square) {
    suggestedMoves.clear();
    final piece = _game.get(square);
    if (piece == null || piece.color != _game.turn) return;
    final moves = _game.generate_moves();
    for (var move in moves) {
      if (move.from == square) {
        // Changed from move['from'] to move.from
        suggestedMoves.add(
          move.to.toString(),
        ); // Changed from move['to'] to move.to
      }
    }
  }

  void onSquareTapped(String square) {
    try {
      final piece = _game.get(square);
      if (selectedSquare.value == null) {
        if (piece != null && piece.color == _game.turn) {
          selectedSquare.value = square;
          _generateMoveSuggestions(square);
          update();
        }
      } else {
        final move = {'from': selectedSquare.value!, 'to': square};
        final isValidMove = _game.move(move);
        if (isValidMove) {
          loadBoard();
        }
        selectedSquare.value = null;
        suggestedMoves.clear();
        update();
      }
    } catch (e) {
      print("Error processing move: $square | Error: $e");
      selectedSquare.value = null;
      suggestedMoves.clear();
      update();
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
