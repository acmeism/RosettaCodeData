/*
 *   Opens an 800x600 16bit color window.
 *   Done here with ANSI C.
 */

#include <stdio.h>
#include <stdlib.h>
#include "SDL.h"

int main()
{
  SDL_Surface *screen;

  if (SDL_Init(SDL_INIT_VIDEO) != 0) {
    fprintf(stderr, "Unable to initialize SDL: %s\n", SDL_GetError());
    return 1;
  }
  atexit(SDL_Quit);
  screen = SDL_SetVideoMode( 800, 600, 16, SDL_SWSURFACE | SDL_HWPALETTE );

  return 0;
}
