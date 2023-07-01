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
0 value diceThrow
fvariable x
fvariable y
variable transformation

: initFern ( -- )
  $20 sdl-init drop
  s\" Rosetta Task : Barnsley fern\x0" drop 0 0 1000 1000 $0 sdl-createwindow to window
  window -1 $2 sdl-createrenderer to renderer
  renderer 0 255 0 255 sdl-setdrawcolor drop
;
: closeFern sdl-quit ;

: f1
  0e0 x f!
  y f@ 0.16e0 f* y f!
;
: f2
  x f@  0.85e0 f* y f@ 0.040e0 f* f+
  x f@ -0.04e0 f* y f@ 0.850e0 f* f+ 1.600e0 f+   y f!
  x f!
;
: f3
  x f@ 0.200e0 f* y f@ -0.260e0 f* f+
  x f@ 0.230e0 f* y f@  0.220e0 f* f+ 1.600e0 f+   y f!
  x f!
;
: f4
  x f@ -0.150e0 f* y f@ 0.280e0 f* f+
  x f@  0.260e0 f* y f@ 0.240e0 f* f+  0.440e0 f+    y f!
  x f!
;

: fern
initFern
0e0 x f!
0e0 y f!
20000 0 do
  renderer x f@ 50e0 f* f>s 500 + y f@ 50e0 f* f>s sdl-drawpoint drop
  100 random to diceThrow
  ['] f2 transformation !
  diceThrow 15 < if ['] f4 transformation ! then
  diceThrow 8 < if ['] f3 transformation ! then
  diceThrow 1 < if ['] f1 transformation ! then
  transformation @ execute
loop
  renderer sdl-renderpresent
  5000 sdl-delay
closeFern
;

fern
