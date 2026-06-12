import java.util.*;



// Main class for testing
class ChessEngine {
    public static void testChess() {

        // Position with check
        String fenCheck = "4k3/8/8/7Q/8/8/8/4K3 b - - 0 1";
        Board boardCheck = Board.parseFEN(fenCheck);
        System.out.println("--- Position with Black in Check ---");
        boardCheck.print();
        System.out.println("\nIs Black king in check? " + boardCheck.inCheck('b'));
        List<Move> movesCheck = boardCheck.getLegalMoves();
        System.out.println("\nLegal moves for Black (to get out of check or make other moves):");



        // Starting position
        String fenStart = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
        Board boardStart = Board.parseFEN(fenStart);
        System.out.println("--- Starting Position ---");
        boardStart.print();
        List<Move> movesStart = boardStart.getLegalMoves();
        System.out.println("\nLegal moves for Black (to get out of check or make other moves):");
        if (movesCheck.isEmpty()) {
            System.out.println("No legal moves. (This might indicate checkmate or stalemate)");
        } else {
            for (Move move : movesCheck) {
                System.out.println("- " + move);
            }
        }
        System.out.println("Total legal moves: " + movesCheck.size());
        System.out.println("\n" + "=".repeat(40) + "\n");

        // Mid-game position
        String fenMidgame = "r3k2r/p1ppqpb1/bn2pn1p/3PP1p1/1p2P3/2N2N2/PPPBBPPP/R2QK2R w KQkq - 0 1";
        Board boardMidgame = Board.parseFEN(fenMidgame);
        System.out.println("--- Mid-game Position (White to move) ---");
        boardMidgame.print();
        List<Move> movesMidgame = boardMidgame.getLegalMoves();
        System.out.println("\nLegal moves for White:");
        if (movesMidgame.isEmpty()) {
            System.out.println("No legal moves.");
        } else {
            for (Move move : movesMidgame) {
                System.out.println("- " + move);
            }
        }
        System.out.println("Total legal moves: " + movesMidgame.size());
        System.out.println("\n" + "=".repeat(40) + "\n");

        // Castling position
        String fenCastlingWhite = "r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1";
        Board boardCastlingWhite = Board.parseFEN(fenCastlingWhite);
        System.out.println("--- Position Allowing White Castling ---");
        boardCastlingWhite.print();
        List<Move> movesCastlingWhite = boardCastlingWhite.getLegalMoves();
        System.out.println("\nLegal moves for White (including castling):");
        if (movesCastlingWhite.isEmpty()) {
            System.out.println("No legal moves.");
        } else {
            for (Move move : movesCastlingWhite) {
                System.out.println("- " + move);
            }
        }
        System.out.println("Total legal moves: " + movesCastlingWhite.size());
        System.out.println("\n" + "=".repeat(40) + "\n");

        // Pawn promotion position
        String fenPromotion = "8/4P2k/8/8/8/8/8/R3K2R w KQkq - 0 1";
        Board boardPromotion = Board.parseFEN(fenPromotion);
        System.out.println("--- Position Allowing Pawn Promotion ---");
        boardPromotion.print();
        List<Move> movesPromotion = boardPromotion.getLegalMoves();
        System.out.println("\nLegal moves for White (including pawn promotions):");
        if (movesPromotion.isEmpty()) {
            System.out.println("No legal moves.");
        } else {
            for (Move move : movesPromotion) {
                System.out.println("- " + move);
            }
        }
        System.out.println("Total legal moves: " + movesPromotion.size());
        System.out.println("\n" + "=".repeat(40) + "\n");

        // En passant position
        String fenEnpassant = "rnbqkbnr/ppp1p1pp/8/3pPp2/8/8/PPPP1PPP/RNBQKBNR w KQkq f6 0 3";
        Board boardEnpassant = Board.parseFEN(fenEnpassant);
        System.out.println("--- Position Allowing En Passant ---");
        boardEnpassant.print();
        List<Move> movesEnpassant = boardEnpassant.getLegalMoves();
        System.out.println("\nLegal moves for White (including en passant capture):");
        if (movesEnpassant.isEmpty()) {
            System.out.println("No legal moves.");
        } else {
            for (Move move : movesEnpassant) {
                System.out.println("- " + move);
            }
        }
        System.out.println("Total legal moves: " + movesEnpassant.size());
        System.out.println("\n" + "=".repeat(40) + "\n");

        // Stalemate position
        String fenStalemate = "8/8/8/8/8/6k1/5b2/7K w - - 12 95";
        Board boardStalemate = Board.parseFEN(fenStalemate);
        System.out.println("--- Stalemate Position ---");
        boardStalemate.print();
        List<Move> movesStalemate = boardStalemate.getLegalMoves();
        System.out.println("\nLegal moves for White (should be none):");
        if (movesStalemate.isEmpty()) {
            System.out.println("No legal moves. (This indicates stalemate)");
        } else {
            for (Move move : movesStalemate) {
                System.out.println("- " + move);
            }
        }
        System.out.println("Total legal moves: " + movesStalemate.size());
        System.out.println("\n" + "=".repeat(40) + "\n");
    }

    public static void main(String[] args) {
        testChess();
    }

}


// Chess Piece class
class Piece {
    private char type; // 'P', 'R', 'N', 'B', 'Q', 'K'
    private char color; // 'w', 'b'

    public Piece(char type, char color) {
        this.type = type;
        this.color = color;
    }

    public char getType() { return type; }
    public char getColor() { return color; }

    @Override
    public String toString() {
        return color == 'w' ? String.valueOf(type) : String.valueOf(Character.toLowerCase(type));
    }
}

// Chess Move class
class Move {
    private int startRow, startCol, endRow, endCol;
    private Piece promotionPiece; // for pawn promotion

    public Move(int startRow, int startCol, int endRow, int endCol) {
        this(startRow, startCol, endRow, endCol, null);
    }

    public Move(int startRow, int startCol, int endRow, int endCol, Piece promotionPiece) {
        this.startRow = startRow;
        this.startCol = startCol;
        this.endRow = endRow;
        this.endCol = endCol;
        this.promotionPiece = promotionPiece;
    }

    public int getStartRow() { return startRow; }
    public int getStartCol() { return startCol; }
    public int getEndRow() { return endRow; }
    public int getEndCol() { return endCol; }
    public Piece getPromotionPiece() { return promotionPiece; }

    // Convert (row, col) 1-based position to algebraic notation
    public static String algebraic(int row, int col) {
        char file = (char)('a' + (col - 1));
        char rank = (char)('8' - (row - 1));
        return "" + file + rank;
    }

    @Override
    public String toString() {
        String result = algebraic(startRow, startCol) + algebraic(endRow, endCol);
        if (promotionPiece != null && promotionPiece.getType() == 'P' && (endRow == 1 || endRow == 8)) {
            result += "=" + promotionPiece.getType();
        }
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Move move = (Move) obj;
        return startRow == move.startRow && startCol == move.startCol &&
               endRow == move.endRow && endCol == move.endCol &&
               Objects.equals(promotionPiece, move.promotionPiece);
    }

    @Override
    public int hashCode() {
        return Objects.hash(startRow, startCol, endRow, endCol, promotionPiece);
    }
}

// Chess Board class
class Board {
    private Piece[][] squares;
    private char turn; // 'w' or 'b'
    private String castlingRights; // "KQkq"
    private int[] enPassant; // [row, col] or [0, 0] if none
    private int halfMoveClock;
    private int fullMoveClock;

    public Board(Piece[][] squares, char turn, String castlingRights, int[] enPassant, int halfMoveClock, int fullMoveClock) {
        this.squares = new Piece[8][8];
        for (int i = 0; i < 8; i++) {
            System.arraycopy(squares[i], 0, this.squares[i], 0, 8);
        }
        this.turn = turn;
        this.castlingRights = castlingRights;
        this.enPassant = Arrays.copyOf(enPassant, 2);
        this.halfMoveClock = halfMoveClock;
        this.fullMoveClock = fullMoveClock;
    }

    public Piece getPieceAt(int row, int col) {
        return squares[row - 1][col - 1]; // Convert to 0-based indexing
    }

    public char getTurn() { return turn; }
    public String getCastlingRights() { return castlingRights; }
    public int[] getEnPassant() { return enPassant; }

    // Convert algebraic notation to (row, col) tuple
    public static int[] algebraicToTuple(String alg) {
        if (alg.length() != 2 || alg.equals("-")) return new int[]{0, 0};
        char file = alg.charAt(0);
        char rank = alg.charAt(1);
        int col = file - 'a' + 1;
        int row = '8' - rank + 1;
        return new int[]{row, col};
    }

    // Parse FEN string
    public static Board parseFEN(String fen) {
        String[] parts = fen.split(" ");
        String boardStr = parts[0];
        char turnChar = parts[1].charAt(0);
        String castlingRights = parts[2];
        int[] enPassant = algebraicToTuple(parts[3]);
        int halfMove = Integer.parseInt(parts[4]);
        int fullMove = Integer.parseInt(parts[5]);

        Piece[][] squares = new Piece[8][8];
        int row = 0, col = 0;

        for (char c : boardStr.toCharArray()) {
            if (c == '/') {
                row++;
                col = 0;
            } else if (Character.isDigit(c)) {
                int numEmpty = Character.getNumericValue(c);
                for (int i = 0; i < numEmpty; i++) {
                    squares[row][col] = null;
                    col++;
                }
            } else {
                char color = Character.isUpperCase(c) ? 'w' : 'b';
                char pieceType = Character.toUpperCase(c);
                squares[row][col] = new Piece(pieceType, color);
                col++;
            }
        }

        return new Board(squares, turnChar, castlingRights, enPassant, halfMove, fullMove);
    }

    // Print board
    public void print() {
        System.out.println("  a b c d e f g h");
        System.out.println(" +-----------------+");
        for (int r = 0; r < 8; r++) {
            System.out.print((8 - r) + "|");
            for (int c = 0; c < 8; c++) {
                Piece piece = squares[r][c];
                if (piece == null) {
                    System.out.print(" .");
                } else {
                    System.out.print(" " + piece);
                }
            }
            System.out.println(" |" + (8 - r));
        }
        System.out.println(" +-----------------+");
        System.out.println("  a b c d e f g h");
        System.out.println("Current turn: " + (turn == 'w' ? "White" : "Black"));
        System.out.println("Castling rights: " + castlingRights);
    }

    // Check if square is valid
    public static boolean isValidSquare(int row, int col) {
        return row >= 1 && row <= 8 && col >= 1 && col <= 8;
    }

    // Apply move and return new board
    public Board makeMove(Move move) {
        Piece[][] newSquares = new Piece[8][8];
        for (int i = 0; i < 8; i++) {
            System.arraycopy(squares[i], 0, newSquares[i], 0, 8);
        }

        Piece movingPiece = getPieceAt(move.getStartRow(), move.getStartCol());
        if (movingPiece == null) return this;

        // Handle castling
        if (movingPiece.getType() == 'K' && Math.abs(move.getStartCol() - move.getEndCol()) == 2) {
            int kingRow = move.getStartRow();
            if (move.getEndCol() == 7) { // kingside castling
                newSquares[kingRow - 1][6] = movingPiece;
                newSquares[kingRow - 1][move.getStartCol() - 1] = null;
                Piece rook = getPieceAt(kingRow, 8);
                newSquares[kingRow - 1][5] = rook;
                newSquares[kingRow - 1][7] = null;
            } else if (move.getEndCol() == 3) { // queenside castling
                newSquares[kingRow - 1][2] = movingPiece;
                newSquares[kingRow - 1][move.getStartCol() - 1] = null;
                Piece rook = getPieceAt(kingRow, 1);
                newSquares[kingRow - 1][3] = rook;
                newSquares[kingRow - 1][0] = null;
            }
        } else if (movingPiece.getType() == 'P') {
            // Handle en passant
            if (move.getEndCol() != move.getStartCol() && getPieceAt(move.getEndRow(), move.getEndCol()) == null) {
                int targetRow = move.getEndRow() + (movingPiece.getColor() == 'w' ? 1 : -1);
                Piece capturedPiece = getPieceAt(targetRow, move.getEndCol());
                if (capturedPiece != null && capturedPiece.getType() == 'P' &&
                    capturedPiece.getColor() != movingPiece.getColor()) {
                    newSquares[targetRow - 1][move.getEndCol() - 1] = null;
                    newSquares[move.getEndRow() - 1][move.getEndCol() - 1] = movingPiece;
                    newSquares[move.getStartRow() - 1][move.getStartCol() - 1] = null;
                }
            } else {
                // Regular pawn move
                newSquares[move.getEndRow() - 1][move.getEndCol() - 1] = movingPiece;
                newSquares[move.getStartRow() - 1][move.getStartCol() - 1] = null;
            }
        } else {
            // Handle all other moves
            newSquares[move.getEndRow() - 1][move.getEndCol() - 1] = movingPiece;
            newSquares[move.getStartRow() - 1][move.getStartCol() - 1] = null;
        }

        // Update castling rights
        String newCastlingRights = castlingRights;
        if (movingPiece.getType() == 'K') {
            if (movingPiece.getColor() == 'w') {
                newCastlingRights = newCastlingRights.replace("K", "").replace("Q", "");
            } else {
                newCastlingRights = newCastlingRights.replace("k", "").replace("q", "");
            }
        } else if (movingPiece.getType() == 'R') {
            if (movingPiece.getColor() == 'w') {
                if (move.getStartRow() == 8 && move.getStartCol() == 8) {
                    newCastlingRights = newCastlingRights.replace("K", "");
                } else if (move.getStartRow() == 8 && move.getStartCol() == 1) {
                    newCastlingRights = newCastlingRights.replace("Q", "");
                }
            } else {
                if (move.getStartRow() == 1 && move.getStartCol() == 8) {
                    newCastlingRights = newCastlingRights.replace("k", "");
                } else if (move.getStartRow() == 1 && move.getStartCol() == 1) {
                    newCastlingRights = newCastlingRights.replace("q", "");
                }
            }
        }

        if (newCastlingRights.isEmpty()) {
            newCastlingRights = "-";
        }

        // Handle en passant
        int[] newEnPassant = {0, 0};
        if (movingPiece.getType() == 'P' && Math.abs(move.getStartRow() - move.getEndRow()) == 2) {
            newEnPassant[0] = move.getEndRow() + (movingPiece.getColor() == 'w' ? 1 : -1);
            newEnPassant[1] = move.getEndCol();
        }

        char newTurn = (turn == 'w' ? 'b' : 'w');
        return new Board(newSquares, newTurn, newCastlingRights, newEnPassant,
                        halfMoveClock + 1, fullMoveClock + (newTurn == 'b' ? 1 : 0));
    }

    // Find king position
    public int[] findKing(char kingColor) {
        for (int r = 1; r <= 8; r++) {
            for (int c = 1; c <= 8; c++) {
                Piece piece = getPieceAt(r, c);
                if (piece != null && piece.getType() == 'K' && piece.getColor() == kingColor) {
                    return new int[]{r, c};
                }
            }
        }
        return null;
    }

    // Check if square is attacked
    public boolean isSquareAttacked(int row, int col, char attackingColor) {
        // Check pawn attacks
        int pawnDir = (attackingColor == 'w' ? -1 : 1);
        for (int dc : new int[]{-1, 1}) {
            int targetRow = row + pawnDir;
            int targetCol = col + dc;
            if (isValidSquare(targetRow, targetCol)) {
                Piece piece = getPieceAt(targetRow, targetCol);
                if (piece != null && piece.getColor() == attackingColor && piece.getType() == 'P') {
                    return true;
                }
            }
        }

        // Check knight attacks
        int[][] knightMoves = {{-2, -1}, {-2, 1}, {-1, -2}, {-1, 2}, {1, -2}, {1, 2}, {2, -1}, {2, 1}};
        for (int[] move : knightMoves) {
            int targetRow = row + move[0];
            int targetCol = col + move[1];
            if (isValidSquare(targetRow, targetCol)) {
                Piece piece = getPieceAt(targetRow, targetCol);
                if (piece != null && piece.getColor() == attackingColor && piece.getType() == 'N') {
                    return true;
                }
            }
        }

        // Check straight line attacks (rook, queen)
        int[][] straightDirs = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
        for (int[] dir : straightDirs) {
            for (int i = 1; i <= 7; i++) {
                int targetRow = row + i * dir[0];
                int targetCol = col + i * dir[1];
                if (!isValidSquare(targetRow, targetCol)) break;

                Piece piece = getPieceAt(targetRow, targetCol);
                if (piece != null) {
                    if (piece.getColor() == attackingColor &&
                        (piece.getType() == 'R' || piece.getType() == 'Q')) {
                        return true;
                    } else {
                        break;
                    }
                }
            }
        }

        // Check diagonal attacks (bishop, queen)
        int[][] diagonalDirs = {{1, 1}, {1, -1}, {-1, 1}, {-1, -1}};
        for (int[] dir : diagonalDirs) {
            for (int i = 1; i <= 7; i++) {
                int targetRow = row + i * dir[0];
                int targetCol = col + i * dir[1];
                if (!isValidSquare(targetRow, targetCol)) break;

                Piece piece = getPieceAt(targetRow, targetCol);
                if (piece != null) {
                    if (piece.getColor() == attackingColor &&
                        (piece.getType() == 'B' || piece.getType() == 'Q')) {
                        return true;
                    } else {
                        break;
                    }
                }
            }
        }

        // Check king attacks
        int[][] kingMoves = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}};
        for (int[] move : kingMoves) {
            int targetRow = row + move[0];
            int targetCol = col + move[1];
            if (isValidSquare(targetRow, targetCol)) {
                Piece piece = getPieceAt(targetRow, targetCol);
                if (piece != null && piece.getColor() == attackingColor && piece.getType() == 'K') {
                    return true;
                }
            }
        }

        return false;
    }

    // Check if king is in check
    public boolean inCheck(char color) {
        int[] kingPos = findKing(color);
        if (kingPos == null) {
            System.out.println("Warning: King of color " + color + " not found on board.");
            return false;
        }
        char attackingColor = (color == 'w' ? 'b' : 'w');
        return isSquareAttacked(kingPos[0], kingPos[1], attackingColor);
    }

    // Get legal moves
    public List<Move> getLegalMoves() {
        List<Move> allMoves = new ArrayList<>();
        char movingPlayerColor = turn;

        for (int r = 1; r <= 8; r++) {
            for (int c = 1; c <= 8; c++) {
                Piece piece = getPieceAt(r, c);
                if (piece != null && piece.getColor() == movingPlayerColor) {
                    switch (piece.getType()) {
                        case 'P': allMoves.addAll(getPawnMoves(r, c, piece)); break;
                        case 'R': allMoves.addAll(getRookMoves(r, c, piece)); break;
                        case 'N': allMoves.addAll(getKnightMoves(r, c, piece)); break;
                        case 'B': allMoves.addAll(getBishopMoves(r, c, piece)); break;
                        case 'Q': allMoves.addAll(getQueenMoves(r, c, piece)); break;
                        case 'K': allMoves.addAll(getKingMoves(r, c, piece)); break;
                    }
                }
            }
        }

        // Filter out moves that leave king in check
        List<Move> legalMoves = new ArrayList<>();
        for (Move move : allMoves) {
            Board tempBoard = makeMove(move);
            if (!tempBoard.inCheck(movingPlayerColor)) {
                legalMoves.add(move);
            }
        }

        return legalMoves;
    }

    // Get pawn moves
    private List<Move> getPawnMoves(int r, int c, Piece piece) {
        List<Move> moves = new ArrayList<>();
        int direction = (piece.getColor() == 'w' ? -1 : 1);
        int startRank = (piece.getColor() == 'w' ? 7 : 2);

        // Forward move
        int targetRow = r + direction;
        if (isValidSquare(targetRow, c) && getPieceAt(targetRow, c) == null) {
            if (targetRow == 1 || targetRow == 8) { // Promotion
                for (char promotionType : new char[]{'Q', 'R', 'B', 'N'}) {
                    moves.add(new Move(r, c, targetRow, c, new Piece(promotionType, piece.getColor())));
                }
            } else {
                moves.add(new Move(r, c, targetRow, c));
                // Double move from starting position
                if (r == startRank) {
                    int doubleTargetRow = r + 2 * direction;
                    if (isValidSquare(doubleTargetRow, c) && getPieceAt(doubleTargetRow, c) == null) {
                        moves.add(new Move(r, c, doubleTargetRow, c));
                    }
                }
            }
        }

        // Capture moves
        for (int dc : new int[]{-1, 1}) {
            targetRow = r + direction;
            int targetCol = c + dc;
            if (isValidSquare(targetRow, targetCol)) {
                Piece targetPiece = getPieceAt(targetRow, targetCol);
                if ((targetPiece != null && targetPiece.getColor() != piece.getColor()) ||
                    (enPassant[0] == targetRow && enPassant[1] == targetCol)) {
                    moves.add(new Move(r, c, targetRow, targetCol));
                }
            }
        }

        return moves;
    }

    // Get sliding moves (for rook, bishop, queen)
    private List<Move> getSlidingMoves(int r, int c, Piece piece, int[][] directions) {
        List<Move> moves = new ArrayList<>();
        for (int[] dir : directions) {
            for (int i = 1; i <= 7; i++) {
                int targetRow = r + i * dir[0];
                int targetCol = c + i * dir[1];
                if (!isValidSquare(targetRow, targetCol)) break;

                Piece targetPiece = getPieceAt(targetRow, targetCol);
                if (targetPiece == null) {
                    moves.add(new Move(r, c, targetRow, targetCol));
                } else if (targetPiece.getColor() != piece.getColor()) {
                    moves.add(new Move(r, c, targetRow, targetCol));
                    break;
                } else {
                    break;
                }
            }
        }
        return moves;
    }

    private List<Move> getRookMoves(int r, int c, Piece piece) {
        int[][] directions = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}};
        return getSlidingMoves(r, c, piece, directions);
    }

    private List<Move> getBishopMoves(int r, int c, Piece piece) {
        int[][] directions = {{1, 1}, {1, -1}, {-1, 1}, {-1, -1}};
        return getSlidingMoves(r, c, piece, directions);
    }

    private List<Move> getQueenMoves(int r, int c, Piece piece) {
        int[][] directions = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}, {1, 1}, {1, -1}, {-1, 1}, {-1, -1}};
        return getSlidingMoves(r, c, piece, directions);
    }

    private List<Move> getKnightMoves(int r, int c, Piece piece) {
        List<Move> moves = new ArrayList<>();
        int[][] knightOffsets = {{-2, -1}, {-2, 1}, {-1, -2}, {-1, 2}, {1, -2}, {1, 2}, {2, -1}, {2, 1}};
        for (int[] offset : knightOffsets) {
            int targetRow = r + offset[0];
            int targetCol = c + offset[1];
            if (isValidSquare(targetRow, targetCol)) {
                Piece targetPiece = getPieceAt(targetRow, targetCol);
                if (targetPiece == null || targetPiece.getColor() != piece.getColor()) {
                    moves.add(new Move(r, c, targetRow, targetCol));
                }
            }
        }
        return moves;
    }

    private List<Move> getKingMoves(int r, int c, Piece piece) {
        List<Move> moves = new ArrayList<>();
        int[][] kingOffsets = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}};
        for (int[] offset : kingOffsets) {
            int targetRow = r + offset[0];
            int targetCol = c + offset[1];
            if (isValidSquare(targetRow, targetCol)) {
                Piece targetPiece = getPieceAt(targetRow, targetCol);
                if (targetPiece == null || targetPiece.getColor() != piece.getColor()) {
                    moves.add(new Move(r, c, targetRow, targetCol));
                }
            }
        }

        // Castling
        char kingColor = piece.getColor();
        char opponentColor = (kingColor == 'w' ? 'b' : 'w');
        if (inCheck(kingColor)) return moves;

        int initialKingRow = (kingColor == 'w' ? 8 : 1);
        if (!(r == initialKingRow && c == 5)) return moves;

        // Kingside castling
        if (kingColor == 'w' && castlingRights.contains("K")) {
            if (getPieceAt(initialKingRow, 6) == null && getPieceAt(initialKingRow, 7) == null) {
                Piece rook = getPieceAt(initialKingRow, 8);
                if (rook != null && rook.getType() == 'R' && rook.getColor() == kingColor) {
                    if (!isSquareAttacked(initialKingRow, 5, opponentColor) &&
                        !isSquareAttacked(initialKingRow, 6, opponentColor) &&
                        !isSquareAttacked(initialKingRow, 7, opponentColor)) {
                        moves.add(new Move(r, c, initialKingRow, 7));
                    }
                }
            }
        }

        // Queenside castling
        if (kingColor == 'w' && castlingRights.contains("Q")) {
            if (getPieceAt(initialKingRow, 2) == null && getPieceAt(initialKingRow, 3) == null &&
                getPieceAt(initialKingRow, 4) == null) {
                Piece rook = getPieceAt(initialKingRow, 1);
                if (rook != null && rook.getType() == 'R' && rook.getColor() == kingColor) {
                    if (!isSquareAttacked(initialKingRow, 5, opponentColor) &&
                        !isSquareAttacked(initialKingRow, 4, opponentColor) &&
                        !isSquareAttacked(initialKingRow, 3, opponentColor)) {
                        moves.add(new Move(r, c, initialKingRow, 3));
                    }
                }
            }
        }

        // Black castling
        if (kingColor == 'b' && castlingRights.contains("k")) {
            if (getPieceAt(initialKingRow, 6) == null && getPieceAt(initialKingRow, 7) == null) {
                Piece rook = getPieceAt(initialKingRow, 8);
                if (rook != null && rook.getType() == 'R' && rook.getColor() == kingColor) {
                    if (!isSquareAttacked(initialKingRow, 5, opponentColor) &&
                        !isSquareAttacked(initialKingRow, 6, opponentColor) &&
                        !isSquareAttacked(initialKingRow, 7, opponentColor)) {
                        moves.add(new Move(r, c, initialKingRow, 7));
                    }
                }
            }
        }

        if (kingColor == 'b' && castlingRights.contains("q")) {
            if (getPieceAt(initialKingRow, 2) == null && getPieceAt(initialKingRow, 3) == null &&
                getPieceAt(initialKingRow, 4) == null) {
                Piece rook = getPieceAt(initialKingRow, 1);
                if (rook != null && rook.getType() == 'R' && rook.getColor() == kingColor) {
                    if (!isSquareAttacked(initialKingRow, 5, opponentColor) &&
                        !isSquareAttacked(initialKingRow, 4, opponentColor) &&
                        !isSquareAttacked(initialKingRow, 3, opponentColor)) {
                        moves.add(new Move(r, c, initialKingRow, 3));
                    }
                }
            }
        }

        return moves;
    }
}
