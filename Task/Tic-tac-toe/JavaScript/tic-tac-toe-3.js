/*
	
	Board Positions:			Win Lines by Id:
	0|1|2						0 ---   |  |  |   \/
	3|4|5						1 ---   |  |  |   /\
	6|7|8						2 ---   |  |  |  6  7
										3  4  5

	About: This is a "too clever by half" way of checking for wins.
	To explain, let's first consider some other ways to check for wins:
											
	- Naive: if( (board[0] == pin && board[1] == pin && board[2] == pin)) return true; ... and repeat for all other win lines

	- Bitboard optimized: if ( (board & WIN_LINE1) == WIN_LINE1 || (board & WIN_LINE2) ... and repeat for all other win lines
	
    - Hash: Maybe we could just hash the winning values? Nope: in general, the "noise" from other pins requires too many states to be practical

    - Regex: See the PHP example of this: https://rosettacode.org/wiki/Tic-tac-toe#PHP
	
    - Base 4 method: But, can we do better?!?!? What is the limit of the maximum we can parallelize our win checking?
      Dare we quixotically hope for a Game-Terminal check of O(1)?  YES!!  Yes, indeed!
      And, that is what the follow is:  An optimized way of win checking using some clever abuses of numbering systems,
      (and uhm, by doing a little bit more work in the makeMove function).  But, trade-offs, doncha know...
	
    Overview:  The insight into the way this works, is that instead of looking at the board state, we are instead going to focus on counting the pins in a win line.
    For example, what if we had counters like this:
			
				 X|.|. --> Win Line 0 Count = 1
				 X|X|. --> Win Line 1 Count = 2
				 X|.|. --> Win Line 2 Count = 1
				   \-----> Win Lines 3,4,5,6,7  = 3,1,0,2,2 respectively
						
    This is sufficient to let us know when there is a win. But, of course, just like the other methods, it requires multiple checks to determine if there is a winning line.

    But, we note that the count won't exceed three or four, so let's serialize the counters into a base4 string, (where each digit is the count for a win line).

    Giving us [2 2 0 1 3 1 2 1].b4 [41433].b10 for the example above.  (With Win Line 0 starting in the Least-Significant-Bit on the right)

    Now, this seems a bit promising, as the winning count of three is right there in the middle of the string of digits.  Now, if we could just
    find some way to filter it out. But, what way might that be?
			
    The hack: Perhaps there's a more elegant solution? (Let me know if you find one...)
    Regardless, a functional, if ugly method we can use is to take advantage of the overlap between base 4, and binary.  This allows us to keep our count "logic" in base 4,
    but still use bitwise operations to check in parallel.

    Expanding on this, we start counting at ONE, rather than ZERO - relying on the fact that it will then overflow to the next digit when it reaches a count of 4,
    since we are working in base 4.
    (Note: This does require us to double the digits used for counting in our base 4 serialized string, in order to keep the win lines from intersecting each other.)

    Here is the initial base 4 win line count, with all the lines starting off empty:
    [01 01 01 01 01 01 01 01].b4  [286331153].b10

    And for the example above we have the following:

    [03 03 01 02 10 02 03 02].b4  [856834610].b10

    Finally, in the binary version of the win line string, (with four binary digits corresponding to the two base 4 digits), it can be seen that the count "overflow",
    (and thus a win), is going to be "visible" as a bit set in the third of the 4 binary digits group corresponding to the base 4 count.
    [0011 0011 0001 0010 0100 0010 0011 0010].b2
                          ^--- Here

    The advantage of this, is that now we can create a bitwise mask to target only those third bits like this:
    [0100 0100 0100 0100 0100 0100 0100 0100].b2
      ^    ^    ^    ^    ^    ^    ^    ^

    Then, just do a bitwise AND against that overflow mask, and Bob's your uncle!

    Admittedly, this is indeed overkill for TicTacToe, but it could theoretically have potential uses with larger N-in-a-row games.
			
*/
const LINE_COUNTS = [0x11111111, 0x11111111]; // [01 01 01 01 01 01 01 01].b4
const WIN_MASK = 0x44444444; // [10 10 10 10 10 10 10 10].b4
const LINES_BY_POS = [
	0x1001001,  //Pos 0 - [00 01 00 00 01 00 00 01].b4
	0x10001,    //Pos 1 - [00 00 00 01 00 00 00 01].b4
	0x10100001, //Pos 2 - [01 00 01 00 00 00 00 01].b4
	0x1010,     //Pos 3 - [00 00 00 00 01 00 01 00].b4
	0x11010010, //Pos 4 - [01 01 00 01 00 00 01 00].b4
	0x100010,   //Pos 5 - [00 00 01 00 00 00 01 00].b4
	0x10001100, //Pos 6 - [01 00 00 00 01 01 00 00].b4
	0x10100,    //Pos 7 - [00 00 00 01 00 01 00 00].b4
	0x1100100,  //Pos 8 - [00 01 01 00 00 01 00 00].b4
];


function isGameOver(turn) {
	if ( (LINE_COUNTS[turn] & WIN_LINE)) return true; //This is the entire glorious raison d'etre for all the above rigamarole
	else if (moveCount >= TOTAL_MOVES) return true;//Cat's game
	else return false;
}

function makeMove(pos) {
	//Update state
	LINE_COUNTS[turn] += LINES_BY_POS[pos]; //Win line accounting
	moveCount++;
}
