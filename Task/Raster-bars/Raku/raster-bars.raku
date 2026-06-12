unit sub MAIN (
    Int :b(:$bar-height) is copy = 60; #= Height of the individual "Raster bars", minimum 32 (pixels)
    Int :d(:$dir) is copy        = -1; #= Scroll direction: -1 is "up" 1 is "down"
    Int :s(:$step) is copy       = 4;  #= Scroll speed (pixels per step
    Int :g(:$gap) is copy        = $bar-height + 50; #= Gap between bars (pixels)
    Int :a(:$angle) is copy      = 0; #= Angle to orient bars off horizontal (-60 to 60 degrees)
    Int :sw(:$sway) is copy      = 0; #= Swaying on / off
    Real :r(:$rnd) is copy       = 0; #= Delay between randomize events
);

say q:to/END/;

    Use Up / Down arrows to change the scroll speed.
    Use Left / Right arrows to adjust the gap between the raster bars.
    Use Pg Up / Pg Dn to adjust raster bar height.
    Use Z / X to change the angle of the raster bars.
    Use Space bar to pause / resume scrolling.
    Use Left Ctrl to toggle the scroll direction.
    Press R to toggle Randomize on / off.
    If Randomize is active, adjust the randomize delay with < / >
    Press S to toggle Swaying on / off.
    If Swaying is active, adjust the period with D / F
    Press Q to exit.
    END

use SDL2::Raw;
use Cairo;

my $width  = 800;
my $height = 800;

SDL_Init(VIDEO);

my $window = SDL_CreateWindow(
    'Raster Bars - Raku',
    SDL_WINDOWPOS_CENTERED_MASK,
    SDL_WINDOWPOS_CENTERED_MASK,
    $width, $height, RESIZABLE
);

my $render = SDL_CreateRenderer($window, -1, ACCELERATED +| PRESENTVSYNC);

my @bars = (^128).map: { gen-bar( rand xx 3 ) };

my $event = SDL_Event.new;

enum KEY_CODES (
    K_UP     => 82,
    K_DOWN   => 81,
    K_LEFT   => 80,
    K_RIGHT  => 79,
    K_SPACE  => 44,
    K_PGUP   => 75,
    K_PGDN   => 78,
    K_LCTRL  => 224,
    K_Z      => 29,
    K_X      => 27,
    K_Q      => 20,
    K_R      => 21,
    K_S      => 22,
    K_D      => 7,
    K_F      => 9,
    K_LT     => 54,
    K_GT     => 55,
);

my $port  = +@bars * $gap;
my $y     = $dir > 0 ?? $height - $port !! $height ;
my $now   = now;
my $period = 2;

main: loop {
    handle-event($event) while SDL_PollEvent($event);

    randomize if $rnd and now - $now > $rnd;

    if $dir > 0 {
        $y = $height - $port if $y > 0 - ceiling $height / cos(π * $angle / 180).abs
    } else {
        $y = 0 - ceiling $height / cos(π * $angle / 180).abs if $y < $height - $port
    }

    $y = $step * $dir + $y;

    $angle = (((now * $period) % τ).sin * 35).Int if $sway;

    for ^@bars {
        my $offset = $sway ?? $gap !! ceiling $gap / cos(π * $angle / 180).abs;
        SDL_RenderCopyEx( $render, @bars[$_], Nil,
          SDL_Rect.new( -($width*4), $y + $offset * $_, $width * 10, $bar-height),
          $angle.Num, SDL_Point.new(:x((4.5*$width).Int),:y($y + $offset * $_)), 0

        )
    }

    SDL_RenderPresent($render);

    SDL_RenderClear($render);

    print fps;
}

put '';

SDL_Quit();

sub gen-bar (@color) {
    my $bar = Cairo::Image.create( Cairo::FORMAT_ARGB32, 1, 128 );
    given Cairo::Context.new($bar) {
        my Cairo::Pattern::Gradient::Linear $lpat .= create(0.0, 0.0,  0.0, 128.0);
        $lpat.add_color_stop_rgba(  1, |(@color »*» .3), 1);
        $lpat.add_color_stop_rgba( .2, |(@color),        1);
        $lpat.add_color_stop_rgba(.75, |(@color),        1);
        $lpat.add_color_stop_rgba(  0, |(@color »+» .5), 1);
        .rectangle(0, 0, 1, 128);
        .pattern($lpat);
        .fill;
        $lpat.destroy;
    }

    my $bar_texture = SDL_CreateTexture(
        $render, %PIXELFORMAT<ARGB8888>,
        STATIC, 1, 128
    );

    SDL_UpdateTexture(
        $bar_texture,
        SDL_Rect.new(:x(0), :y(0), :w(1), :h(128)),
        $bar.data, $bar.stride // 1
    );

    $bar_texture
}

sub handle-event ($event) {
    my $casted_event = SDL_CastEvent($event);
    given $casted_event {
        when *.type == QUIT    { last main }
        when *.type == KEYDOWN {
            if KEY_CODES(.scancode) -> $comm {
                given $comm {
                    when 'K_UP'     { $step += 1 }
                    when 'K_DOWN'   { $step -= 1 if $step > 1 }
                    when 'K_LEFT'   { $gap = $gap < 32 ?? $gap !! $gap - 1; $port = +@bars * $gap; }
                    when 'K_RIGHT'  { $gap++; $port += +@bars; }
                    when 'K_PGUP'   { $bar-height += 2 }
                    when 'K_PGDN'   { $bar-height = $bar-height >= 34 ?? $bar-height - 2 !! $bar-height }
                    when 'K_SPACE'  { $step = $step ?? 0 !! 1 }
                    when 'K_LCTRL'  { $dir  *= -1 }
                    when 'K_Z'      { $angle = $angle > -45 ?? $angle - 5 !! $angle }
                    when 'K_X'      { $angle = $angle <  45 ?? $angle + 5 !! $angle }
                    when 'K_R'      { $rnd = $rnd ?? 0 !! 1 }
                    when 'K_S'      { $sway xor= 1 }
                    when 'K_F'      { $period += .1 }
                    when 'K_D'      { $period = $period - .1 max .1;  }
                    when 'K_GT'     { $rnd += .2 }
                    when 'K_LT'     { $rnd = $rnd > .2 ?? $rnd -.2 !! .2 }
                    when 'K_Q'      { last main }
                }
            } #else { say .scancode, "\n" }
        }
        when *.type == WINDOWEVENT {
            if .event == RESIZED {
                $width  = .data1;
                $height = .data2 + $bar-height;
            }
        }
    }
}

sub randomize {
    $dir   = (-1,1).pick;
    $step  = (4..8).pick;
    $bar-height   = (32..200).pick;
    $gap   = $bar-height + (1..100).pick;
    $angle = (-45, *+5 ... 45).pick;

    $port = +@bars * $gap;

    if $dir > 0 {
        $y = $height - $port;
    } else {
        $y = 0 - ceiling ($height max $width) / cos(π * $angle / 180).abs;
    }
    $now = now;
}

sub fps {
    state $fps-frames = 0;
    state $fps-now    = now;
    state $fps        = '';
    $fps-frames++;
    if now - $fps-now >= 1 {
        $fps = [~] "\b" x 40, ' ' x 20, "\b" x 20 ,
            sprintf "FPS: %5.2f  ", ($fps-frames / (now - $fps-now)).round(.01);
        $fps-frames = 0;
        $fps-now = now;
    }
    $fps
}
