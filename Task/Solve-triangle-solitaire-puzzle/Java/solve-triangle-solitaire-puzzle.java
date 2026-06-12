import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Stack;

public class IQPuzzle {

    public static void main(String[] args) {
        System.out.printf("  ");
        for ( int start = 1 ; start < Puzzle.MAX_PEGS ; start++ ) {
            System.out.printf("  %,6d", start);
        }
        System.out.printf("%n");
        for ( int start = 1 ; start < Puzzle.MAX_PEGS ; start++ ) {
            System.out.printf("%2d", start);
            Map<Integer,Integer> solutions = solve(start);
            for ( int end = 1 ; end < Puzzle.MAX_PEGS ; end++ ) {
                System.out.printf("  %,6d", solutions.containsKey(end) ? solutions.get(end) : 0);
            }
            System.out.printf("%n");
        }
        int moveNum = 0;
        System.out.printf("%nOne Solution:%n");
        for ( Move m : oneSolution ) {
            moveNum++;
            System.out.printf("Move %d = %s%n", moveNum, m);
        }
    }

    private static List<Move> oneSolution = null;

    private static Map<Integer, Integer> solve(int emptyPeg) {
        Puzzle puzzle = new Puzzle(emptyPeg);
        Map<Integer,Integer> solutions = new HashMap<>();
        Stack<Puzzle> stack = new Stack<Puzzle>();
        stack.push(puzzle);
        while ( ! stack.isEmpty() ) {
            Puzzle p = stack.pop();
            if ( p.solved() ) {
                solutions.merge(p.getLastPeg(), 1, (v1,v2) -> v1 + v2);
                if ( oneSolution == null ) {
                    oneSolution = p.moves;
                }
                continue;
            }
            for ( Move move : p.getValidMoves() ) {
                Puzzle pMove = p.move(move);
                stack.add(pMove);
            }
        }
        //System.out.println("Puzzles tested = " + puzzlesTested);
        return solutions;
    }

    private static class Puzzle {

        public static int MAX_PEGS = 16;
        private boolean[] pegs = new boolean[MAX_PEGS];  //  true : peg in hole.  false : hole is empty.

        private List<Move> moves;

        public Puzzle(int emptyPeg) {
            for ( int i = 1 ; i < MAX_PEGS ; i++ ) {
                pegs[i] = true;
            }
            pegs[emptyPeg] = false;
            moves = new ArrayList<>();
        }

        public Puzzle() {
            for ( int i = 1 ; i < MAX_PEGS ; i++ ) {
                pegs[i] = true;
            }
            moves = new ArrayList<>();
        }

        private static Map<Integer,List<Move>> validMoves = new HashMap<>();
        static {
            validMoves.put(1, Arrays.asList(new Move(1, 2, 4), new Move(1, 3, 6)));
            validMoves.put(2, Arrays.asList(new Move(2, 4, 7), new Move(2, 5, 9)));
            validMoves.put(3, Arrays.asList(new Move(3, 5, 8), new Move(3, 6, 10)));
            validMoves.put(4, Arrays.asList(new Move(4, 2, 1), new Move(4, 5, 6), new Move(4, 8, 13), new Move(4, 7, 11)));
            validMoves.put(5, Arrays.asList(new Move(5, 8, 12), new Move(5, 9, 14)));
            validMoves.put(6, Arrays.asList(new Move(6, 3, 1), new Move(6, 5, 4), new Move(6, 9, 13), new Move(6, 10, 15)));
            validMoves.put(7, Arrays.asList(new Move(7, 4, 2), new Move(7, 8, 9)));
            validMoves.put(8, Arrays.asList(new Move(8, 5, 3), new Move(8, 9, 10)));
            validMoves.put(9, Arrays.asList(new Move(9, 5, 2), new Move(9, 8, 7)));
            validMoves.put(10, Arrays.asList(new Move(10, 6, 3), new Move(10, 9, 8)));
            validMoves.put(11, Arrays.asList(new Move(11, 7, 4), new Move(11, 12, 13)));
            validMoves.put(12, Arrays.asList(new Move(12, 8, 5), new Move(12, 13, 14)));
            validMoves.put(13, Arrays.asList(new Move(13, 12, 11), new Move(13, 8, 4), new Move(13, 9, 6), new Move(13, 14, 15)));
            validMoves.put(14, Arrays.asList(new Move(14, 13, 12), new Move(14, 9, 5)));
            validMoves.put(15, Arrays.asList(new Move(15, 14, 13), new Move(15, 10, 6)));
        }

        public List<Move> getValidMoves() {
            List<Move> moves = new ArrayList<Move>();
            for ( int i = 1 ; i < MAX_PEGS ; i++ ) {
                if ( pegs[i] ) {
                    for ( Move testMove : validMoves.get(i) ) {
                        if ( pegs[testMove.jump] && ! pegs[testMove.end] ) {
                            moves.add(testMove);
                        }
                    }
                }
            }
            return moves;
        }

        public boolean solved() {
            boolean foundFirstPeg = false;
            for ( int i = 1 ; i < MAX_PEGS ; i++ ) {
                if ( pegs[i] ) {
                    if ( foundFirstPeg ) {
                        return false;
                    }
                    foundFirstPeg = true;
                }
            }
            return true;
        }

        public Puzzle move(Move move) {
            Puzzle p = new Puzzle();
            if ( ! pegs[move.start] || ! pegs[move.jump] || pegs[move.end] ) {
                throw new RuntimeException("Invalid move.");
            }
            for ( int i = 1 ; i < MAX_PEGS ; i++ ) {
                p.pegs[i] = pegs[i];
            }
            p.pegs[move.start] = false;
            p.pegs[move.jump] = false;
            p.pegs[move.end] = true;
            for ( Move m : moves ) {
                p.moves.add(new Move(m.start, m.jump, m.end));
            }
            p.moves.add(new Move(move.start, move.jump, move.end));
            return p;
        }

        public int getLastPeg() {
            for ( int i = 1 ; i < MAX_PEGS ; i++ ) {
                if ( pegs[i] ) {
                    return i;
                }
            }
            throw new RuntimeException("ERROR:  Illegal position.");
        }

        @Override
        public String toString() {
            StringBuilder sb = new StringBuilder();
            sb.append("[");
            for ( int i = 1 ; i < MAX_PEGS ; i++ ) {
                sb.append(pegs[i] ? 1 : 0);
                sb.append(",");
            }
            sb.setLength(sb.length()-1);
            sb.append("]");
            return sb.toString();
        }
    }

    private static class Move {
        int start;
        int jump;
        int end;

        public Move(int s, int j, int e) {
            start = s; jump = j; end = e;
        }

        @Override
        public String toString() {
            StringBuilder sb = new StringBuilder();
            sb.append("{");
            sb.append("s=" + start);
            sb.append(", j=" + jump);
            sb.append(", e=" + end);
            sb.append("}");
            return sb.toString();
        }
    }

}
