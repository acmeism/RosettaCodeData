public class Sudoku
{
    private int mBoard[][];
    private int mBoardSize;
    private int mBoxSize;
    private boolean mRowSubset[][];
    private boolean mColSubset[][];
    private boolean mBoxSubset[][];

    public Sudoku(int board[][]) {
        mBoard = board;
        mBoardSize = mBoard.length;
        mBoxSize = (int)Math.sqrt(mBoardSize);
        initSubsets();
    }

    public void initSubsets() {
        mRowSubset = new boolean[mBoardSize][mBoardSize];
        mColSubset = new boolean[mBoardSize][mBoardSize];
        mBoxSubset = new boolean[mBoardSize][mBoardSize];
        for(int i = 0; i < mBoard.length; i++) {
            for(int j = 0; j < mBoard.length; j++) {
                int value = mBoard[i][j];
                if(value != 0) {
                    setSubsetValue(i, j, value, true);
                }
            }
        }
    }

    private void setSubsetValue(int i, int j, int value, boolean present) {
        mRowSubset[i][value - 1] = present;
        mColSubset[j][value - 1] = present;
        mBoxSubset[computeBoxNo(i, j)][value - 1] = present;
    }

    public boolean solve() {
        return solve(0, 0);
    }

    public boolean solve(int i, int j) {
        if(i == mBoardSize) {
            i = 0;
            if(++j == mBoardSize) {
                return true;
            }
        }
        if(mBoard[i][j] != 0) {
            return solve(i + 1, j);
        }
        for(int value = 1; value <= mBoardSize; value++) {
            if(isValid(i, j, value)) {
                mBoard[i][j] = value;
                setSubsetValue(i, j, value, true);
                if(solve(i + 1, j)) {
                    return true;
                }
                setSubsetValue(i, j, value, false);
            }
        }

        mBoard[i][j] = 0;
        return false;
    }

    private boolean isValid(int i, int j, int val) {
        val--;
        boolean isPresent = mRowSubset[i][val] || mColSubset[j][val] || mBoxSubset[computeBoxNo(i, j)][val];
        return !isPresent;
    }

    private int computeBoxNo(int i, int j) {
        int boxRow = i / mBoxSize;
        int boxCol = j / mBoxSize;
        return boxRow * mBoxSize + boxCol;
    }

    public void print() {
        for(int i = 0; i < mBoardSize; i++) {
            if(i % mBoxSize == 0) {
                System.out.println(" -----------------------");
            }
            for(int j = 0; j < mBoardSize; j++) {
                if(j % mBoxSize == 0) {
                    System.out.print("| ");
                }
                System.out.print(mBoard[i][j] != 0 ? ((Object) (Integer.valueOf(mBoard[i][j]))) : "-");
                System.out.print(' ');
            }

            System.out.println("|");
        }

        System.out.println(" -----------------------");
    }

    public static void main(String[] args) {
        int[][] board = {
            {8, 5, 0, 0, 0, 2, 4, 0, 0},
            {7, 2, 0, 0, 0, 0, 0, 0, 9},
            {0, 0, 4, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 1, 0, 7, 0, 0, 2},
            {3, 0, 5, 0, 0, 0, 9, 0, 0},
            {0, 4, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 8, 0, 0, 7, 0},
            {0, 1, 7, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 3, 6, 0, 4, 0}
        };
        Sudoku s = new Sudoku(board);
        System.out.print("Starting grid:\n");
        s.print();
        if (s.solve()) {
            System.out.print("\nSolution:\n");
            s.print();
        } else {
            System.out.println("\nUnsolvable!");
        }
    }
}
