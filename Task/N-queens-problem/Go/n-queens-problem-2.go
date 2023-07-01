/*
 * N-Queens Problem
 *
 * For an NxN chess board, 'safely' place a chess queen in every column and row such that none can attack another.
 * This solution is based Wirth Pascal solution, although a tad cleaner, thus easier to understand as it uses Go/C
 * style indexing and naming, and also prints the Queen using a Unicode 'rune' (which other languages do not handle natively).
 *
 * N rows by N columns are number left to right top to bottom 0 - 7
 *
 * There are 2N-1 diagonals (showing an 8x8)
 *  the upper-right to lower-left are numbered row + col that is:
 *    0   1   2   3   4   5   6   7
 *    1   2   3   4   5   6   7   8
 *    2   3   4   5   6   7   8   9
 *    3   4   5   6   7   8   9  10
 *    4   5   6   7   8   9  10  11
 *    5   6   7   8   9  10  11  12
 *    6   7   8   9  10  11  12  13
 *    7   8   9  10  11  12  13  14
 *
 *	the upper-left to lower-right are numbered N-1 + row - col
 *    7   6   5   4   3   2   1   0
 *    8   7   6   5   4   3   2   1
 *    9   8   7   6   5   4   3   2
 *   10   9   8   7   6   5   4   3
 *   11  10   9   8   7   6   5   4
 *   12  11  10   9   8   7   6   5
 *   13  12  11  10   9   8   7   6
 *   14  13  12  11  10   9   8   7
 */

package main

import "fmt"

const	N	= 8
const	HAS_QUEEN  = false
const	EMPTY  = true
const	UNASSIGNED = -1
const   white_queen = '\u2655'


var	row_num[N]int	// results, indexed by row will be the column where the queen lives (UNASSIGNED) is empty
var	right_2_left_diag[(2*N-1)]bool	// T if no queen in diag[idx]: row i, column col is diag i+col
var	left_2_right_diag[(2*N-1)]bool //  T is no queen in diag[idx], row i, column col is N-1 + i-col


func printresults() {
    for col := 0; col < N; col++ {
	if col != 0 {
	    fmt.Printf(" ");
	}
	fmt.Printf("%d,%d", col, row_num[col])
    }
    fmt.Printf("\n");
    for  row := 0; row < N; row++ {
	for col := 0; col < N; col++ {
	    if col == row_num[row] {
		fmt.Printf(" %c ", white_queen)
	    } else {
		fmt.Printf(" . ")
	    }
	}
	fmt.Printf("\n")
    }
}

/*
 * save a queen on the board by saving where we think it should go, and marking the diagonals as occupied
 */

func savequeen(row int, col int) {
    row_num[row] = col	// save queen column for this row
    right_2_left_diag[row+col] = HAS_QUEEN 	// mark forward diags as occupied
    left_2_right_diag[row-col+(N-1)] = HAS_QUEEN	// mark backward diags as occupied
}

/*
 * backout a previously saved queen by clearing where we put it, and marking the diagonals as empty
 */

func clearqueen(row int, col int) {
    row_num[row] = UNASSIGNED
    right_2_left_diag[row+col] = EMPTY
    left_2_right_diag[row-col+(N-1)] = EMPTY
}

/*
 * for each column try the solutions
 */
func trycol(col int)  bool {
	// check each row to look for the first empty row that does not have a diagonal in use too
	for row := 0; row < N; row++ {
            if row_num[row] == UNASSIGNED &&	// has the row been used yet?
		    right_2_left_diag[row+col] == EMPTY &&	// check for the forward diags
		    left_2_right_diag[row-col+(N-1)] == EMPTY {	// check for the backwards diags
	        savequeen(row, col)	// this is a possible solution
	        // Tricky part here:  going forward thru the col up to but not including the rightmost one
                // if this fails, we are done, no need to search any more
                if col < N-1 && !trycol(col+1) {
		    // ok this did not work - we need to try a different row, so undo the guess
		    clearqueen(row, col)
	        } else {
		    // we have a solution on this row/col, start popping the stack.
		    return true
		}
	    }
	}
	return false // not a solution for this col, pop the stack, undo the last guess, and try the next one
}

func main() {
    for i := 0; i < N ; i++ {
	row_num[i] = UNASSIGNED
    }
    for i := 0; i < 2*N-1 ; i++ {
	right_2_left_diag[i] = EMPTY
    }
    for i := 0; i < 2*N-1 ; i++ {
	left_2_right_diag[i] = EMPTY
    }
    trycol(0)
    printresults()
}
