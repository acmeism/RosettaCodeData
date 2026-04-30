2000 constant QUANTITY
500 constant HEIGHT
500 constant WIDTH

s" SDL2" add-lib
\c #include <SDL2/SDL.h>
c-function sdl-init				SDL_Init				n -- n
c-function sdl-quit				SDL_Quit				-- void
c-function sdl-createwindow		SDL_CreateWindow		a n n n n n -- a
c-function sdl-createrenderer	SDL_CreateRenderer		a n n -- a
c-function sdl-setdrawcolor		SDL_SetRenderDrawColor	a n n n n -- n
c-function sdl-drawpoint		SDL_RenderDrawPoint		a n n -- n
c-function sdl-renderpresent	SDL_RenderPresent		a -- void
c-function sdl-renderclear		SDL_RenderClear			a -- n
c-function sdl-delay            SDL_Delay               n -- void

require random.fs

0 value window
0 value renderer

create particles QUANTITY 4 * cells allot
: xpos   ( n -- addr ) 4 *          cells particles + ;
: ypos   ( n -- addr ) 4 * 1+       cells particles + ;
: xspeed ( n -- addr ) 4 * 1+ 1+    cells particles + ;
: yspeed ( n -- addr ) 4 * 1+ 1+ 1+ cells particles + ;

: cls
  renderer 255 255 255 255 sdl-setdrawcolor drop
  renderer sdl-renderclear drop
  renderer 0 0 0 255 sdl-setdrawcolor drop
;

: initGfx ( -- )
  $20 sdl-init drop
  s\" Rosetta Task : Particule fountain\x0" drop 0 0 WIDTH HEIGHT $0 sdl-createwindow to window
  window -1 $2 sdl-createrenderer to renderer
  cls
;

: inject ( particule# -- )
  WIDTH 2 / over xpos  !
  HEIGHT 1- over ypos  !
  30 random 15 - over xspeed  !
  80 random 10 + negate swap yspeed  !
;
: initialstate    QUANTITY 0 do  i inject loop ;

: display
  cls
  QUANTITY 0 do
    renderer I xpos @ I ypos @ sdl-drawpoint drop
  loop
  renderer sdl-renderpresent
;

: step-x ( particle# -- )  dup xspeed @ swap xpos +!  ;
: step-y ( particle# -- )  dup yspeed @ swap ypos +!  ;
: clip-y ( particle# -- )  dup ypos @ HEIGHT > if inject else drop then ;
: step-s ( particle# -- )  HEIGHT 50 /    swap yspeed +!  ;
: step    QUANTITY 0 do    I step-x    I step-y    I clip-y    I step-s    loop ;

: fountain
initialstate initgfx
begin
  display
  step
  100 sdl-delay
key? until
key drop
sdl-quit
;


fountain
