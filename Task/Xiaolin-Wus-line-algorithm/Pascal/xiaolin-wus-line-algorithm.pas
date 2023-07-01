program wu;
uses
  SDL2,
  math;

const
  FPS = 1000 div 60;
  SCALE = 6;

var
  win: PSDL_Window;
  ren: PSDL_Renderer;
  mouse_x, mouse_y: longint;
  origin: TSDL_Point;
  event: TSDL_Event;
  line_alpha: byte = 255;

procedure SDL_RenderDrawWuLine(renderer: PSDL_Renderer; x1, y1, x2, y2: longint);
var
  r, g, b, a, a_new: Uint8;
  gradient, iy: real;
  x, y: longint;
  px, py: plongint;

  procedure swap(var a, b: longint);
  var
    tmp: longint;
  begin
    tmp := a;
    a := b;
    b := tmp;
  end;

begin
  if a = 0 then
    exit;
  SDL_GetRenderDrawColor(renderer, @r, @g, @b, @a);
  if abs(y2 - y1) > abs(x2 - x1) then
    begin
      swap(x1, y1);
      swap(x2, y2);
      px := @y;
      py := @x;
    end
  else
    begin
      px := @x;
      py := @y;
    end;
  if x1 > x2 then
    begin
      swap(x1, x2);
      swap(y1, y2);
    end;
  x := x2 - x1;
  if x = 0 then
    x := 1;
  gradient := (y2 - y1) / x;
  iy := y1;
  for x := x1 to x2 do
    begin
      a_new := round(a * frac(iy));
      y := floor(iy);
      SDL_SetRenderDrawColor(renderer, r, g, b, a-a_new);
      SDL_RenderDrawPoint(renderer, px^, py^);
      inc(y);
      SDL_SetRenderDrawColor(renderer, r, g, b, a_new);
      SDL_RenderDrawPoint(renderer, px^, py^);
      iy := iy + gradient;
    end;
  SDL_SetRenderDrawColor(renderer, r, g, b, a);
end;

begin
  SDL_Init(SDL_INIT_VIDEO);
  win := SDL_CreateWindow('Xiaolin Wu''s line algorithm', SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
                        640, 480, SDL_WINDOW_RESIZABLE);
  ren := SDL_CreateRenderer(win, -1, 0);
  if ren = NIL then
    begin
      writeln(SDL_GetError);
      halt;
    end;
  SDL_SetRenderDrawBlendMode(ren, SDL_BLENDMODE_BLEND);
  SDL_RenderSetScale(ren, SCALE, SCALE);
  SDL_SetCursor(SDL_CreateSystemCursor(SDL_SYSTEM_CURSOR_CROSSHAIR));

  mouse_x := 0;
  mouse_y := 0;
  origin.x := 0;
  origin.y := 0;
  repeat
    while SDL_PollEvent(@event) = 1 do
      case event.type_ of
        SDL_KEYDOWN:
          if event.key.keysym.sym = SDLK_ESCAPE then
            halt;
        SDL_MOUSEBUTTONDOWN:
          begin
            origin.x := mouse_x;
            origin.y := mouse_y;
          end;
        SDL_MOUSEMOTION:
          with event.motion do
            begin
              mouse_x := x div SCALE;
              mouse_y := y div SCALE;
            end;
        SDL_MOUSEWHEEL:
          line_alpha := EnsureRange(line_alpha + event.wheel.y * 20, 0, 255);
        SDL_QUITEV:
          halt;
      end;

    SDL_SetRenderDrawColor(ren, 35, 35, 35, line_alpha);
    SDL_RenderDrawWuLine(ren, origin.x, origin.y, mouse_x, mouse_y);
    SDL_RenderPresent(ren);
    SDL_SetRenderDrawColor(ren, 255, 255, 255, 255);
    SDL_RenderClear(ren);
    SDL_Delay(FPS);
  until false;
end.
