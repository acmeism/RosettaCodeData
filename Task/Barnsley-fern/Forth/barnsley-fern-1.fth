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

require random.fs

0 value window
0 value renderer
variable x
variable y

: initFern ( -- )
  $20 sdl-init drop
  s\" Rosetta Task : Barnsley fern\x0" drop 0 0 1000 1000 $0 sdl-createwindow to window
  window -1 $2 sdl-createrenderer to renderer
  renderer 0 255 0 255 sdl-setdrawcolor drop
;

create coefficients
             0 ,    0 ,   0 , 160 ,    0 ,    \  1% of the time - f1
           200 , -260 , 230 , 220 , 1600 ,    \  7% of the time - f3
          -150 ,  280 , 260 , 240 ,  440 ,    \  7% of the time - f4
           850 ,   40 , -40 , 850 , 1600 ,    \ 85% of the time - f2

: nextcoeff ( n -- n+1 coeff ) coefficients over cells + @ swap 1+ swap ;
: transformation ( n -- )
  nextcoeff x @ *   swap nextcoeff y @ *    rot + 1000 /   swap
  nextcoeff x @ *   swap nextcoeff y @ *    rot + 1000 /   swap nextcoeff rot +    y ! drop
  x !  \ x shall be modified after y calculation
;
: randomchoice ( -- index )
  100 random
  dup 0 > swap
  dup 7 > swap
  dup 14 > swap drop
  + + negate 5 *
;

: fern
initFern
20000 0 do
  randomchoice transformation
  renderer x @ 10 / 500 + y @ 10 / sdl-drawpoint drop
loop
renderer sdl-renderpresent
5000 sdl-delay
sdl-quit
;

fern
