use SDL2::Raw;

my $width  = 900;
my $height = 900;

SDL_Init(VIDEO);

my $window = SDL_CreateWindow(
    'Polyspiral',
    SDL_WINDOWPOS_CENTERED_MASK,
    SDL_WINDOWPOS_CENTERED_MASK,
    $width, $height,
    RESIZABLE
);

my $render = SDL_CreateRenderer($window, -1, ACCELERATED +| PRESENTVSYNC);

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
    K_PLUS   => 87,
    K_MINUS  => 86,
    K_SPLUS  => 46,
    K_SMINUS => 45,
);

my $angle = 0;
my $lines = 240;
my @rgb = palette($lines);
my ($x1, $y1);
my $dir = 1;
my $rot = 0;
my $incr = .0001/π;
my $step = $incr*70;

main: loop {
    while SDL_PollEvent($event) {
        my $casted_event = SDL_CastEvent($event);
        given $casted_event {
            when *.type == QUIT { last main }
            when *.type == KEYDOWN {
                if KEY_CODES(.scancode) -> $comm {
                    given $comm {
                        when 'K_LEFT'   { $dir = $rot ??  1 !! -1 }
                        when 'K_RIGHT'  { $dir = $rot ?? -1 !!  1 }
                        when 'K_UP'     { $step += $incr }
                        when 'K_DOWN'   { $step -= $incr if $step > $incr }
                        when 'K_PGUP'   { $step += $incr*50 }
                        when 'K_PGDN'   { $step -= $incr*50; $step = $step < $incr ?? $incr !! $step }
                        when 'K_SPACE'  { $step = $step ?? 0 !! $incr }
                        when 'K_LCTRL'  { $rot  = $rot  ?? 0 !! -1; $dir *= -1 }
                        when 'K_PLUS'   { $lines = ($lines + 5) min 360; @rgb = palette($lines) }
                        when 'K_SPLUS'  { $lines = ($lines + 5) min 360; @rgb = palette($lines) }
                        when 'K_MINUS'  { $lines = ($lines - 5) max 60;  @rgb = palette($lines) }
                        when 'K_SMINUS' { $lines = ($lines - 5) max 60;  @rgb = palette($lines) }
                    }
                }
                #say .scancode; # unknown key pressed
            }
            when *.type == WINDOWEVENT {
                if .event == 5 {
                    $width  = .data1;
                    $height = .data2;
                }
            }
        }
    }

    $angle = ($angle + $dir * $step) % τ;
    ($x1, $y1) = $width div 2, $height div 2;
    my $dim = $width min $height;
    my $scale = (2 + .33 * abs(π - $angle)) * $dim / $lines;
    $scale *= ($angle > π) ?? (1 - $angle/τ) !! $angle/τ;
    $scale max= $dim/$lines/$lines;
    for ^$lines {
        my $length = $scale + $scale * $_;
        my ($x2, $y2) = ($x1, $y1) «+« cis(($angle * $rot * $lines) + $angle * $_).reals »*» $length;
        SDL_SetRenderDrawColor($render, |@rgb[$_], 255);
        SDL_RenderDrawLine($render, |($x1, $y1, $x2, $y2)».round(1));
        ($x1, $y1) = $x2, $y2;
    }
    @rgb.=rotate($lines/60);
    SDL_RenderPresent($render);
    SDL_SetRenderDrawColor($render, 0, 0, 0, 0);
    SDL_RenderClear($render);
}

SDL_Quit();

sub palette ($l) { (^$l).map: { hsv2rgb(($_ * 360/$l % 360)/360, 1, 1).list } };

sub hsv2rgb ( $h, $s, $v ){ # inputs normalized 0-1
    my $c = $v * $s;
    my $x = $c * (1 - abs( (($h*6) % 2) - 1 ) );
    my $m = $v - $c;
    my ($r, $g, $b) = do given $h {
        when   0..^(1/6) { $c, $x, 0 }
        when 1/6..^(1/3) { $x, $c, 0 }
        when 1/3..^(1/2) { 0, $c, $x }
        when 1/2..^(2/3) { 0, $x, $c }
        when 2/3..^(5/6) { $x, 0, $c }
        when 5/6..1      { $c, 0, $x }
    }
    ( $r, $g, $b ).map: ((*+$m) * 255).Int
}
