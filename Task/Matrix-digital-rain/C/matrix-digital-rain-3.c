/*******************************************************************************
*
* Digital ASCII rain - multithreaded.
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


//#define SYNCHRONIZED_INIT


/*
 * Global variables, common for all threads.
 * The handle eventThreadInitialized is to synchronize threads initializations.
 */
#ifdef SYNCHRONIZED_INIT
HANDLE eventThreadInitialized;
#endif

BOOL                       loop = TRUE; /* FALSE - przerwać działanie */
HANDLE                     hStdOut;     /* uchwyt do konsoli "out" */
CONSOLE_SCREEN_BUFFER_INFO csbi;        /* liczby wierszy i kolumn itd.*/


struct InitThreadData
{
  int      column;
  unsigned seed;
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
  return rnd(0,150) + rnd(0,150) + rnd(0,150);
}

BOOL randomRegenerate(void)
{
  return rnd(0,99) < 2;
}


/*
 * Update a single column.
 */
void one_column(void *arg)
{
  BOOL show;
  int  k;
  char c;
  WORD a;
  int  delay;
  PCHAR_INFO buffer;
  COORD bufferSize, bufferCoord, newCharPosition;
  SMALL_RECT s, d;
  DWORD result;

  /*
   * Retrieve the column number, initialize the (pseudo)random numbers
   * generator with a "private" seed, check assertions.
   */
  k = ((struct InitThreadData*)arg)->column;
  srand(((struct InitThreadData*)arg)->seed);
  assert(csbi.dwSize.X != 0 && csbi.dwSize.Y != 0);
  assert(0 <= k && k <= csbi.dwSize.X);

  show   = randomShow();
  delay  = randomDelay();

  bufferSize.X = 1;
  bufferSize.Y = csbi.dwSize.Y - 1;
  bufferCoord.X = 0;
  bufferCoord.Y = 0;

  buffer = (PCHAR_INFO)malloc(bufferSize.Y * sizeof(CHAR_INFO));
  assert( buffer != NULL );

  s.Left   = k;
  s.Top    = 0;
  s.Bottom = bufferSize.Y - 2;
  s.Right  = k;

  d.Left   = s.Left;
  d.Top    = s.Top + 1;
  d.Right  = s.Right;
  d.Bottom = s.Bottom + 1;

  newCharPosition.X = k;
  newCharPosition.Y = 0;

#ifdef SYNCHRONIZED_INIT
  SetEvent(eventThreadInitialized);
#endif

  /*
   * Main loop inside this one thread.
   */
  while(loop)
  {
    ReadConsoleOutput ( hStdOut, buffer, bufferSize, bufferCoord, &s);
    WriteConsoleOutput( hStdOut, buffer, bufferSize, bufferCoord, &d);

    if(show)
    {
      c = (rnd(1,100) <= 15) ? ' ' : rnd( 'a', 'z' );
      a = FOREGROUND_GREEN | ((rnd(1,100) >  1) ? 0 : FOREGROUND_INTENSITY);
    }
    else
    {
      c = ' ';
      a = FOREGROUND_GREEN;
    }

    WriteConsoleOutputCharacter( hStdOut, &c, 1, newCharPosition, &result );
    WriteConsoleOutputAttribute( hStdOut, &a, 1, newCharPosition, &result );

    if(randomRegenerate())  show  = randomShow();
    if(randomRegenerate())  delay = randomDelay();

    Sleep( delay );
  }

  free(buffer);
}


int main(int argc, char* argv[])
{
  int j;
  struct InitThreadData *init = NULL;

  srand((time_t)time(NULL));

  hStdOut = GetStdHandle( STD_OUTPUT_HANDLE );
  SetConsoleTitle("MATRIX");

  if(argc == 1)
  {
    COORD coord;
    CONSOLE_CURSOR_INFO cci;

    cci.bVisible = FALSE;
    cci.dwSize   = 0;
    SetConsoleDisplayMode(hStdOut,CONSOLE_FULLSCREEN_MODE,&coord);
    SetConsoleCursorInfo(hStdOut,&cci);
  }

  GetConsoleScreenBufferInfo( hStdOut, &csbi );
  //SetConsoleTextAttribute(hStdOut,FOREGROUND_GREEN);

#ifdef SYNCHRONIZED_INIT
  eventThreadInitialized = CreateEvent(NULL,FALSE,FALSE,NULL);
  assert( eventThreadInitialized != NULL );
#endif

  init = (struct InitThreadData*)
          malloc(csbi.dwSize.X * sizeof(struct InitThreadData));
  assert( init != NULL );

  for(j = 0; j < csbi.dwSize.X; j++)
  {
    init[j].column = j;
    init[j].seed = rand();
    _beginthread(one_column, 0, (void*)&init[j]);
#ifdef SYNCHRONIZED_INIT
    WaitForSingleObject(eventThreadInitialized,INFINITE);
#endif
  }

  getchar();
  free(init);

#ifdef SYNCHRONIZED_INIT
  CloseHandle(eventThreadInitialized);
#endif SYNCHRONIZED_INIT

  return 0;
}
