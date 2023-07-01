\ Bindings to SDL2 functions
s" SDL2" add-lib
\c #include <SDL2/SDL.h>
c-function sdl-init		SDL_Init		n -- n
c-function sdl-quit		SDL_Quit		-- void
c-function sdl-createwindow	SDL_CreateWindow	a n n n n n -- a
c-function sdl-createrenderer	SDL_CreateRenderer	a n n -- a
c-function sdl-setdrawcolor	SDL_SetRenderDrawColor	a n n n n -- n
c-function sdl-drawpoint	SDL_RenderDrawPoint	a n n -- n
c-function sdl-renderpresent	SDL_RenderPresent	a -- void
c-function sdl-delay            SDL_Delay               n -- void

: pixel ( -- )
  $20 sdl-init drop
  s\" Rosetta Task : Draw a pixel\x0" drop 0 0 320 240 $0 sdl-createwindow
  ( window ) -1 $2 sdl-createrenderer

  dup ( renderer ) 255 0 0 255 sdl-setdrawcolor drop
  dup ( renderer ) 100 100 sdl-drawpoint drop
      ( renderer ) sdl-renderpresent

  5000 sdl-delay
  sdl-quit
;

pixel
