import java.util.*;

public class PuzzleGame {
    private static final int EASY = 1;
    private static final int HARD = 4;
    private static int[] n = new int[16];
    private static Random rand = new Random();
    private static Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {
        initGrid();
        int level = EASY;
        while (true) {
            System.out.print("Enter difficulty level easy or hard E/H : ");
            String diff = scanner.nextLine().trim().toUpperCase();
            if (diff.equals("E") || diff.equals("H")) {
                if (diff.equals("H")) {
                    level = HARD;
                }
                break;
            } else {
                System.out.println("Invalid response, try again.");
            }
        }
        setDiff(level);
        int[] ix = new int[4];
        System.out.println("When entering moves, you can also enter Q to quit or S to start again.");
        int moves = 0;
        outer:
        while (true) {
            drawGrid();
            if (hasWon()) {
                System.out.println("Congratulations, you have won the game in " + moves + " moves!!");
                return;
            }
            while (true) {
                System.out.println("Moves so far = " + moves + "\n");
                System.out.print("Enter move : ");
                String move = scanner.nextLine().trim().toUpperCase();
                switch (move) {
                    case "D1":
                    case "D2":
                    case "D3":
                    case "D4":
                        int c = move.charAt(1) - '1';
                        ix[0] = 0 + c;
                        ix[1] = 4 + c;
                        ix[2] = 8 + c;
                        ix[3] = 12 + c;
                        rotate(ix);
                        moves++;
                        continue outer;
                    case "L1":
                    case "L2":
                    case "L3":
                    case "L4":
                        c = move.charAt(1) - '1';
                        ix[0] = 3 + 4 * c;
                        ix[1] = 2 + 4 * c;
                        ix[2] = 1 + 4 * c;
                        ix[3] = 0 + 4 * c;
                        rotate(ix);
                        moves++;
                        continue outer;
                    case "U1":
                    case "U2":
                    case "U3":
                    case "U4":
                        c = move.charAt(1) - '1';
                        ix[0] = 12 + c;
                        ix[1] = 8 + c;
                        ix[2] = 4 + c;
                        ix[3] = 0 + c;
                        rotate(ix);
                        moves++;
                        continue outer;
                    case "R1":
                    case "R2":
                    case "R3":
                    case "R4":
                        c = move.charAt(1) - '1';
                        ix[0] = 0 + 4 * c;
                        ix[1] = 1 + 4 * c;
                        ix[2] = 2 + 4 * c;
                        ix[3] = 3 + 4 * c;
                        rotate(ix);
                        moves++;
                        continue outer;
                    case "Q":
                        return;
                    case "S":
                        initGrid();
                        setDiff(level);
                        moves = 0;
                        continue outer;
                    default:
                        System.out.println("Invalid move, try again.");
                }
            }
        }
    }

    private static void initGrid() {
        for (int i = 0; i < 16; i++) {
            n[i] = i + 1;
        }
    }

    private static void setDiff(int level) {
        int moves = 3;
        if (level == HARD) {
            moves = 12;
        }
        List<Integer> rc = new ArrayList<>();
        for (int i = 0; i < moves; i++) {
            rc.clear();
            int r = rand.nextInt(2);
            int s = rand.nextInt(4);
            if (r == 0) { // rotate random row
                for (int j = s * 4; j < (s + 1) * 4; j++) {
                    rc.add(j);
                }
            } else { // rotate random column
                for (int j = s; j < s + 16; j += 4) {
                    rc.add(j);
                }
            }
            int[] rca = new int[4];
            for (int k = 0; k < 4; k++) {
                rca[k] = rc.get(k);
            }
            rotate(rca);
            if (hasWon()) { // do it again
                i = -1;
            }
        }
        System.out.println("Target is " + moves + " moves.");
    }

    private static void drawGrid() {
        System.out.println();
        System.out.println("     D1   D2   D3   D4");
        System.out.println("   ╔════╦════╦════╦════╗");
        System.out.printf("R1 ║ %2d ║ %2d ║ %2d ║ %2d ║ L1\n", n[0], n[1], n[2], n[3]);
        System.out.println("   ╠════╬════╬════╬════╣");
        System.out.printf("R2 ║ %2d ║ %2d ║ %2d ║ %2d ║ L2\n", n[4], n[5], n[6], n[7]);
        System.out.println("   ╠════╬════╬════╬════╣");
        System.out.printf("R3 ║ %2d ║ %2d ║ %2d ║ %2d ║ L3\n", n[8], n[9], n[10], n[11]);
        System.out.println("   ╠════╬════╬════╬════╣");
        System.out.printf("R4 ║ %2d ║ %2d ║ %2d ║ %2d ║ L4\n", n[12], n[13], n[14], n[15]);
        System.out.println("   ╚════╩════╩════╩════╝");
        System.out.println("     U1   U2   U3   U4\n");
    }

    private static void rotate(int[] ix) {
        int last = n[ix[3]];
        for (int i = 3; i >= 1; i--) {
            n[ix[i]] = n[ix[i - 1]];
        }
        n[ix[0]] = last;
    }

    private static boolean hasWon() {
        for (int i = 0; i < 16; i++) {
            if (n[i] != i + 1) {
                return false;
            }
        }
        return true;
    }
}

