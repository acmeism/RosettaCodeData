/*******************************************************************************
*
* Digital ASCII rain - the single thread variant.
* 2012 (C) by Author, 2020 GPL licensed for RossetaCode
*
*******************************************************************************/

#include <assert.h>    /* assertions */
#include <conio.h>     /* console operations */
#include <locale.h>    /* l10n and i18n */
#include <string.h>    /* operations on strings and memory blocks */
#include <process.h>   /* Microsoft Windows API for threads etc. */
#include <stdio.h>     /* standard i/o library */
#include <stdlib.h>    /* standard library with rand() function */
#include <time.h>      /* time(NULL) used as srand(time(NULL)) */
#include <windows.h>   /* just the Microsoft Windows main header for C */


/*
 * Global variables - you could use local variables instead...
 * but then e.g. the memory for the buffer variable would be unnecessarily
 * allocated and released manifold, which would lead to a worse performance.
 */

HANDLE                     hStdOut;     /* the handle to console "out" */
CONSOLE_SCREEN_BUFFER_INFO csbi;        /* numbers of rows, columns etc. */

PCHAR_INFO buffer = NULL;               /* an enough big buffer */
COORD bufferSize, bufferCoord;          /* the size of buffer etc. */


/*
 * A structure that holds data that is distinct for each column.
 */
struct Data
{
  DWORD      armed;  /* time in ms to synchronize */
  int        delay;  /* armed = current_time + delay */
  BOOL       show;   /* TRUE - draw, FALSE - erase */
  COORD      ncp;    /* position for drawing new characters */
  SMALL_RECT s, d;   /* source/destination regions for copy */
};

/*
 * A function to generate random numbers from the range (a, b).
 * NOTE: POSIX rand () is not thread safe,
 * but we use secure rand() from MS runtime libraries.
 */

int rnd(int a, int b)
{
  return a + rand() % (b + 1 - a);
}

BOOL randomShow(void)
{
  return rnd(0, 99) < 65;
}

int randomDelay(void)
{
  return rnd(0, 150) + rnd(0, 150) + rnd(0, 150);
}

BOOL randomRegenerate(void)
{
  return rnd(0, 99) < 2;
}

void column_init(struct Data* data, int k)
{
  data->armed = 0;
  data->show  = randomShow();
  data->delay = randomDelay();

  data->s.Left   = k;
  data->s.Top    = 0;
  data->s.Bottom = bufferSize.Y - 2;
  data->s.Right  = k;

  data->d.Left   = data->s.Left;
  data->d.Top    = data->s.Top + 1;
  data->d.Right  = data->s.Right;
  data->d.Bottom = data->s.Bottom + 1;

  data->ncp.X = k;
  data->ncp.Y = 0;
}


void column_run(struct Data* data)
{
  char c;
  WORD a;
  DWORD result;

  /*
   * Shift down a column.
   */
  ReadConsoleOutput (hStdOut, buffer, bufferSize, bufferCoord, &data->s);
  WriteConsoleOutput(hStdOut, buffer, bufferSize, bufferCoord, &data->d);

  /*
   * If show == TRUE then generate a new character.
   * If show == FALSE write the space to erase.
   */
  if(data->show)
  {
    c = (rnd(1,100) <= 15) ? ' ' : rnd( 'a', 'z' );
    a = FOREGROUND_GREEN | ((rnd(1,100) >  10) ? 0 : FOREGROUND_INTENSITY);
  }
  else
  {
    c = ' ';
    a = FOREGROUND_GREEN;
  }

  WriteConsoleOutputCharacter(hStdOut, &c, 1, data->ncp, &result);
  WriteConsoleOutputAttribute(hStdOut, &a, 1, data->ncp, &result);

  /*
   * Randomly regenerate the delay and the visibility state of the column.
   */
  if(randomRegenerate()) data->show  = randomShow();
  if(randomRegenerate()) data->delay = randomDelay();

  data->armed = GetTickCount() + data->delay;
}


int main(int argc, char* argv[])
{
  int j;
  struct Data* table;

  srand((unsigned int)time(NULL));

  hStdOut = GetStdHandle( STD_OUTPUT_HANDLE );
  SetConsoleTitle("Digital ASCII rain");

  /*
   * An attempt to run in the full-screen mode.
   */
  if(argc == 1)
  {
    COORD coord;
    CONSOLE_CURSOR_INFO cci;
    cci.bVisible = FALSE;
    cci.dwSize   = 0;
    SetConsoleDisplayMode(hStdOut, CONSOLE_FULLSCREEN_MODE, &coord);
    SetConsoleCursorInfo(hStdOut, &cci);
  }

  GetConsoleScreenBufferInfo(hStdOut, &csbi );
  //SetConsoleTextAttribute(hStdOut, FOREGROUND_GREEN);

  bufferSize.X  = 1;
  bufferSize.Y  = csbi.dwSize.Y - 1;
  bufferCoord.X = 0;
  bufferCoord.Y = 0;
  buffer = (PCHAR_INFO)calloc(bufferSize.Y, sizeof(CHAR_INFO));
  assert(buffer != NULL);

  table = (struct Data*)calloc(csbi.dwSize.X, sizeof(struct Data));
  assert(table != NULL);

  for(j = 0; j < csbi.dwSize.X; j++) column_init(&table[j], j);

  /*
   * Main loop. Sleep(1) significally decreases the CPU load.
   */

  while(!_kbhit())
  {
    DWORD t = GetTickCount();
    for(j = 0; j < csbi.dwSize.X; j++)
      if(table[j].armed < t) column_run(&table[j]);
    Sleep(1);
  }

  free(table);
  free(buffer);

  return 0;
}
