use NativeCall;
use SDL2::Raw;

my int ($w, $h) = 800, 800;
my SDL_Window $window;
my SDL_Renderer $renderer;

my int $particlenum = 3000;


SDL_Init(VIDEO);
$window = SDL_CreateWindow(
   "Raku Particle System!",
   SDL_WINDOWPOS_CENTERED_MASK, SDL_WINDOWPOS_CENTERED_MASK,
   $w, $h,
   RESIZABLE
);
$renderer = SDL_CreateRenderer( $window, -1, ACCELERATED );

SDL_ClearError();

my num @positions  = 0e0 xx ($particlenum * 2);
my num @velocities = 0e0 xx ($particlenum * 2);
my num @lifetimes  = 0e0 xx  $particlenum;

my CArray[int32] $points .= new;
my int $numpoints;
my Num $saturation = 4e-1;
my Num $spread = 15e-1;
my &reciprocate = sub { 0 }
my $range = 1.5;

sub update (num \df) {
   my int $xidx = 0;
   my int $yidx = 1;
   my int $pointidx = 0;
   loop (my int $idx = 0; $idx < $particlenum; $idx = $idx + 1) {
       my int $willdraw = 0;
       if (@lifetimes[$idx] <= 0e0) {
           if (rand < df) {
               @lifetimes[$idx]   = 25e-1;                       # time to live
               @positions[$xidx]  = ($w / 20e0).Num;             # starting position x
               @positions[$yidx]  = ($h / 10).Num;               # and y
               @velocities[$xidx] = ($spread * rand - $spread/2 + reciprocate()) * 10; # starting velocity x
               @velocities[$yidx] = (rand - 2.9e0) * $h / 20.5;    # and y (randomized slightly so points reach different heights)
               $willdraw = 1;
           }
       } else {
           if @positions[$yidx] > $h / 10 && @velocities[$yidx] > 0 {
               @velocities[$yidx] = @velocities[$yidx] * -0.3e0; # "bounce"
           }

           @velocities[$yidx] = @velocities[$yidx] + $h/10.Num * df;         # adjust velocity
           @positions[$xidx]  = @positions[$xidx] + @velocities[$xidx] * df; # adjust position x
           @positions[$yidx]  = @positions[$yidx] + @velocities[$yidx] * df; # and y

           @lifetimes[$idx]   = @lifetimes[$idx] - df;
           $willdraw = 1;
       }

       if ($willdraw) {
           $points[$pointidx++] = (@positions[$xidx] * 10).floor; # gather all of the points that
           $points[$pointidx++] = (@positions[$yidx] * 10).floor; # are still going to be rendered
       }

       $xidx = $xidx + 2;
       $yidx = $xidx + 1;
   }
   $numpoints = ($pointidx - 1) div 2;
}

sub render {
   SDL_SetRenderDrawColor($renderer, 0x0, 0x0, 0x0, 0xff);
   SDL_RenderClear($renderer);

   SDL_SetRenderDrawColor($renderer, |hsv2rgb(((now % 5) / 5).round(.01), $saturation, 1), 0x7f);
   SDL_RenderDrawPoints($renderer, $points, $numpoints);

   SDL_RenderPresent($renderer);
}

enum KEY_CODES (
   K_UP     => 82,
   K_DOWN   => 81,
   K_LEFT   => 80,
   K_RIGHT  => 79,
   K_SPACE  => 44,
   K_PGUP   => 75,
   K_PGDN   => 78,
   K_Q      => 20,
);

say q:to/DOCS/;
Use UP and DOWN arrow keys to modify the saturation of the particle colors.
Use PAGE UP and PAGE DOWN keys to modify the "spread" of the particles.
Toggle reciprocation off / on with the SPACE bar.
Use LEFT and RIGHT arrow keys to modify angle range for reciprocation.
Press the "q" key to quit.
DOCS

my $event = SDL_Event.new;

my num $df = 0.0001e0;

main: loop {
   my $start = now;

   while SDL_PollEvent($event) {
       my $casted_event = SDL_CastEvent($event);

       given $casted_event {
           when *.type == QUIT {
               last main;
           }
           when *.type == WINDOWEVENT {
               if .event == RESIZED {
                   $w = .data1;
                   $h = .data2;
               }
           }
           when *.type == KEYDOWN {
               if KEY_CODES(.scancode) -> $comm {
                   given $comm {
                       when 'K_UP'    { $saturation = (($saturation + .1) min 1e0) }
                       when 'K_DOWN'  { $saturation = (($saturation - .1) max 0e0) }
                       when 'K_PGUP'  { $spread = (($spread + .1) min 5e0) }
                       when 'K_PGDN'  { $spread = (($spread - .1) max 2e-1) }
                       when 'K_RIGHT' { $range = (($range + .1) min 2e0) }
                       when 'K_LEFT'  { $range = (($range - .1) max 1e-1) }
                       when 'K_SPACE' { &reciprocate = reciprocate() == 0 ?? sub { $range * sin(now) } !! sub { 0 } }
                       when 'K_Q'     { last main }
                   }
               }
           }
       }
   }

   update($df);

   render();

   $df = (now - $start).Num;

   print fps();
}

say '';

sub fps {
   state $fps-frames = 0;
   state $fps-now    = now;
   state $fps        = '';
   $fps-frames++;
   if now - $fps-now >= 1 {
       $fps = [~] "\r", ' ' x 20, "\r",
           sprintf "FPS: %5.1f  ", ($fps-frames / (now - $fps-now));
       $fps-frames = 0;
       $fps-now = now;
   }
   $fps
}

sub hsv2rgb ( $h, $s, $v ){
   state %cache;
   %cache{"$h|$s|$v"} //= do {
       my $c = $v * $s;
       my $x = $c * (1 - abs( (($h*6) % 2) - 1 ) );
       my $m = $v - $c;
       [(do given $h {
           when   0..^1/6 { $c, $x, 0 }
           when 1/6..^1/3 { $x, $c, 0 }
           when 1/3..^1/2 { 0, $c, $x }
           when 1/2..^2/3 { 0, $x, $c }
           when 2/3..^5/6 { $x, 0, $c }
           when 5/6..1    { $c, 0, $x }
       } ).map: ((*+$m) * 255).Int]
   }
}
