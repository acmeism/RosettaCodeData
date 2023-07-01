#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#define EMPTY_TILE 0
#define ROWS 4
#define COLUMNS 4


/*
 *                                     GENERAL CONCEPT
 *
 * How do you add up tiles when there is whitespace between them?
 * You sort the array so that there are no empty tiles between them while stacking them all to one side
 * then the addition function always adds up from left to right or up to bottom. It does not care
 * about the left movements or the down movement. This can be achieved by reversing the array
 * whenever the player chooses to move to the right or down, when the addition is finished
 * the array gets reversed back and its like it had been added from right to left or bottom to top
 * When the addition is done, the program scans for the number of empty tiles and uses that
 * in its selection of the next tile to be filled. 10% of times a tile gets occupied with a 4
 *
*/



/*
 * the remove_whitespace functions; it is pretty clear what they do.
 * they use a bubble short algorith to move the 0's or empty tiles to the end of the array
 * depending on the direction moved (without carring about going right or up
 *
*/

void remove_whitespace_horizontaly(int board[ROWS][COLUMNS], int rows, int columns)
{
  int a = columns;
  int tmp;


  for (; a < COLUMNS - 1; ++a) {
    tmp = board[rows][a];
    board[rows][a] = board[rows][a+1];
    board[rows][a+1] = tmp;
  }
}

void remove_whitespace_verticaly(int board[ROWS][COLUMNS], int columns, int rows)
{
  int a = rows;
  int tmp;

  for (; a < ROWS - 1; ++a) {
    tmp = board[a][columns];
    board[a][columns] = board[a+1][columns];
    board[a+1][columns] = tmp;
  }
}

/*
 * the add_tiles functions. those functions do the heavy work of adding the tiles and
 * taking care of special situations such as when adding two equal tiles a 0 gets generated
 * they are quite difficult to understand i think (which means not that you need to be too clever
 * but that i have done a poor job of creating them) and it took around 4 hours to get the
 * proper result
*/

void add_tiles_horizontaly(int board[ROWS][COLUMNS])
{
  int a, b, flag;

  for (a = 0; a < ROWS; ++a) {
    for (b = 0, flag = 0; b < COLUMNS - 1 && flag != 4; ++b) {
      if (board[a][b] == EMPTY_TILE) {
	remove_whitespace_horizontaly(board, a, b);
	--b;
	++flag;
      }
      else {
	if (board[a][b+1] == EMPTY_TILE) {
	  board[a][b+1] = board[a][b];
	  board[a][b] = EMPTY_TILE;
	  --b;
	} else if (board[a][b] == board[a][b+1]) {
	  board[a][b] += board[a][b+1];
	  board[a][b+1] = EMPTY_TILE;
	}
      }
    }
  }
}

void add_tiles_verticaly(int board[ROWS][COLUMNS])
{
  int a, b, flag;

  for (a = 0; a < COLUMNS; ++a) {
    for (b = 0, flag = 0; b < ROWS-1 && flag != 4; ++b) {
      if (board[b][a] == EMPTY_TILE) {
	remove_whitespace_verticaly(board, a, b);
	--b;
	++flag;
      }
      else {
	if (board[b+1][a] == EMPTY_TILE) {
	  board[b+1][a] = board[b][a];
	  board[b][a] = EMPTY_TILE;
	  --b;
	} else if (board[b][a] == board[b+1][a]) {
	  board[b][a] += board[b+1][a];
	  board[b+1][a] = EMPTY_TILE;
	}
      }
    }
  }
}
	
/*
 * ... print the board
 */

void print_board(int board[ROWS][COLUMNS])
{
  int a, b;

  for (a = 0; a < ROWS; ++a) {
    printf("\n");
    for (b = 0; b < COLUMNS; ++b) {
      printf("%5i", board[a][b]);
    }
  }
  printf("\n");
}

/*
 * The reverse_board function reverses the array
 * if the movement is right or down reverse the array
*/

void reverse_board(char input[], int board[ROWS][COLUMNS])
{
  int a, b, c, tmp;

  if (!strcmp(input, "right")) {
    for (a = 0; a < ROWS; ++a) {
      for (b = 0, c = 3; b < 2; ++b, --c) {
	tmp = board[a][b];
	board[a][b] = board[a][c];
	board[a][c] = tmp;
      }
    }
  }
  else if  (!strcmp(input, "down")) {
    for (a = 0; a < COLUMNS; ++a) {
      for (b = 0, c = 3; b < 2; ++b, --c) {
	tmp = board[b][a];
	board[b][a] = board[c][a];
	board[c][a] = tmp;
      }
    }
  }
}

/*
 * the check_board function is the one which evaluates the win or lose condition
 * for each turn and at the same time providing the number of empty tiles for the random generator
 * function
*/

int check_board (int board[ROWS][COLUMNS])
{
  int a, b;

  int result = 0;
  int empty_tiles = 0;


  for (a = 0; a < ROWS; ++a)
    for (b = 0; b < COLUMNS; ++b)
      if (board[a][b] == 2048)
	result = -1;
      else if (board[a][b] == EMPTY_TILE)
	++empty_tiles;

  result = result == -1 ? result : empty_tiles;

  return result;
}

/*
 * the generate_random functin generates a random number between 0 and the number of
 * empty tiles. the generated number will assign to the Nth empty tile = (random_number)
 * the new value, it also takes care of the 10% chance for producing a 4 tile
*/

void generate_random(int board[ROWS][COLUMNS], int empty_tiles )
{

  srand(time(NULL));

  int a, b;
  int random = 0;
  int tile = 0;

  random = rand() % empty_tiles;
  tile = (rand() % 9 == 4) ? 4 : 2;

  for (a = 0; a < ROWS; ++a)
    for (b = 0; b < COLUMNS; ++b)
      if (board[a][b] == EMPTY_TILE && random != 0)
	--random;
      else if (board[a][b] == EMPTY_TILE && random == 0) {
	board[a][b] = tile;
	return;
      }
}

/*
 * infinite loop, get the movements or exit code and act accordingly
*/

int play_game(int board[ROWS][COLUMNS])
{

  char movement[81];
  int tiles = 0;

  printf("this is the 2048 game\n"					\
	 "The goal of this game is make a tile reach the value of 2048\n"\
	 "The board starts of with only one occupied tile.\n"\
	 "On each round a new tile gets added with the value of 2\n"\
	 "or at 10%% of the times with the value of 4\n"\
	 "If you run out of tiles you lose\n"\
	 "There are 4 movements you can supply to the game\n"\
	 "right, left, up, and down.\n"\
	 "For each of this movements the tiles move to the direction specified\n"\
	 "If two tiles have the same value the get added up just once.\n"\
	 "If 2 occupied tiles share the same row or column but are seperated by empty tiles\n"\
	 "then the occupied tiles travel along the empty tiles stacking in the direction\n"\
	 "they were directed\n"\
	 "For a more visual explanation you can check the wikipedia entry\n"
	 " if you search for 2058 board game\n"	\
	 "Here we go\n");

  print_board(board);
  while (1) {
    printf("(enter: left,right,up,down,exit)>> ");
    scanf("%s", movement);
    if (!strcmp(movement, "down")) {
      reverse_board(movement,board);
      add_tiles_verticaly(board);
      tiles = check_board(board);
      if (tiles == -1)
	return -1;
      else if (tiles == 0)
	return 0;
      generate_random(board,tiles);
      reverse_board(movement, board);
    }
    else if (!strcmp(movement, "up")) {
      add_tiles_verticaly(board);
      tiles = check_board(board);
      if (tiles == -1)
	return -1;
      else if (tiles == 0)
	return 0;
      generate_random(board,tiles);
    }
    else if (!strcmp(movement, "right")) {
      reverse_board(movement,board);
      add_tiles_horizontaly(board);
      tiles = check_board(board);
      if (tiles == -1)
	return -1;
      else if (tiles == 0)
	return 0;
      generate_random(board,tiles);
      reverse_board(movement, board);
    }
    else if (!strcmp(movement, "left")) {
      add_tiles_horizontaly(board);
      tiles = check_board(board);
      if (tiles == -1)
	return -1;
      else if (tiles == 0)
	return 0;
      generate_random(board,tiles);
    }
    else if (!strcmp(movement, "exit")) {
      return 1;
    }
    else {
      printf("Do not recognize this movement please type again\n");
      continue;
    }
    print_board(board);
  }
}


int main(void)
{
  int play_game(int board[ROWS][COLUMNS]);
  void generate_random(int board[ROWS][COLUMNS], int empty_tiles );
  int check_board (int board[ROWS][COLUMNS]);
  void reverse_board(char input[], int board[ROWS][COLUMNS]);
  void print_board(int board[ROWS][COLUMNS]);
  void add_tiles_verticaly(int board[ROWS][COLUMNS]);
  void add_tiles_horizontaly(int board[ROWS][COLUMNS]);
  void remove_whitespace_verticaly(int board[ROWS][COLUMNS], int columns, int rows);
  void remove_whitespace_horizontaly(int board[ROWS][COLUMNS], int rows, int columns);

  int win_condition;
  int board[ROWS][COLUMNS] = {
    {0,0,0,0},
    {0,0,0,0},
    {0,0,0,0},
    {0,0,0,0}
  };


  generate_random(board, 16); /* initialize the board */

  win_condition = play_game(board);
  switch (win_condition) {
  case 1:
    printf("But you are not done yet!!!\n"	\
	   "Fine, see you another day\n");
    break;
  case 0:
    printf("Ohh noo, you run out of tiles\n"	\
	   "Run me agan to play some more\n"	\
	   "Byyyeee\n");
    break;
  case -1:
    printf("WooooW you did it, Good job!!!\n"	\
	   "See ya later homie\n");
    break;
  }

  return 0;
}
