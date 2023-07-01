/**
 * Loosely emulates the "digital rain" effect from The Matrix.
 *
 * @author Dan Ruscoe <dan@ruscoe.org>
 */
#include <unistd.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <ncurses.h>

/* Time between row updates in microseconds.
   Controls the speed of the digital rain effect.
*/
#define ROW_DELAY 40000

/**
 * Gets a random integer within a given range.
 *
 * @param int min The low-end of the range.
 * @param int max The high-end of the range.
 *
 * @return int The random integer.
 */
int get_rand_in_range(int min, int max)
{
  return (rand() % ((max + 1) - min) + min);
}

int main(void)
{
  /* Basic seed for random numbers. */
  srand(time(NULL));

  /* Characters to randomly appear in the rain sequence. */
  char chars[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};

  int total_chars = sizeof(chars);

  /* Set up ncurses screen and colors. */
  initscr();
  noecho();
  curs_set(FALSE);

  start_color();
  init_pair(1, COLOR_GREEN, COLOR_BLACK);
  attron(COLOR_PAIR(1));

  int max_x = 0, max_y = 0;

  getmaxyx(stdscr, max_y, max_x);

  /* Create arrays of columns based on screen width. */

  /* Array containing the current row of each column. */
  int columns_row[max_x];

  /* Array containing the active status of each column.
     A column draws characters on a row when active.
  */
  int columns_active[max_x];

  int i;

  /* Set top row as current row for all columns. */
  for (i = 0; i < max_x; i++)
  {
    columns_row[i] = -1;
    columns_active[i] = 0;
  }

  while (1)
  {
    for (i = 0; i < max_x; i++)
    {
      if (columns_row[i] == -1)
      {
        /* If a column is at the top row, pick a
           random starting row and active status.
        */
        columns_row[i] = get_rand_in_range(0, max_y);
        columns_active[i] = get_rand_in_range(0, 1);
      }
    }

    /* Loop through columns and draw characters on rows. */
    for (i = 0; i < max_x; i++)
    {
      if (columns_active[i] == 1)
      {
        /* Draw a random character at this column's current row. */
        int char_index = get_rand_in_range(0, total_chars);
        mvprintw(columns_row[i], i, "%c", chars[char_index]);
      }
      else
      {
        /* Draw an empty character if the column is inactive. */
        mvprintw(columns_row[i], i, " ");
      }

      columns_row[i]++;

      /* When a column reaches the bottom row, reset to top. */
      if (columns_row[i] >= max_y)
      {
        columns_row[i] = -1;
      }

      /* Randomly alternate the column's active status. */
      if (get_rand_in_range(0, 1000) == 0)
      {
        columns_active[i] = (columns_active[i] == 0) ? 1 : 0;
      }
    }

    usleep(ROW_DELAY);
    refresh();
  }

  endwin();
  return 0;
}
