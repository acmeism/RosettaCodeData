\ Bindings to SDL2 functions
s" SDL2" add-lib
\c #include <SDL2/SDL.h>
c-function sdl-init	            SDL_Init                n -- n
c-function sdl-quit	            SDL_Quit                -- void
c-function sdl-createwindow     SDL_CreateWindow        a n n n n n -- a
c-function sdl-createrenderer   SDL_CreateRenderer      a n n -- a
c-function sdl-setdrawcolor     SDL_SetRenderDrawColor  a n n n n -- n
c-function sdl-drawpoint        SDL_RenderDrawPoint     a n n -- n
c-function sdl-renderpresent    SDL_RenderPresent       a -- void
c-function sdl-delay            SDL_Delay               n -- void
c-function sdl-ticks            SDL_GetTicks            -- n

require random.fs

0 value window
0 value renderer
240 constant height
320 constant width

: black   0   0   0 255 ;
: white 255 255 255 255 ;
: black-or-white 2 random if black else white then ;

: init-image ( -- )
  $20 sdl-init drop
  s\" Rosetta Task : Image Noise\x0" drop 0 0 width height $0 sdl-createwindow to window
  window -1 $2 sdl-createrenderer to renderer
  page
;

: image-noise-generate
height 0 do
  width 0 do
    renderer black-or-white sdl-setdrawcolor drop
    renderer i j sdl-drawpoint drop
  loop
loop
;

: .FPS swap - 1000 swap / 0 0 at-xy . ." FPS" ;

: image-noise
init-image
100 0 do
  sdl-ticks
  image-noise-generate     renderer sdl-renderpresent
  sdl-ticks .FPS
loop
sdl-quit
;

image-noise
