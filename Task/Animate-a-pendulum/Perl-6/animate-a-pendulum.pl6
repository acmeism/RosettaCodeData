use SDL2::Raw;
use Cairo;

my $width = 1000;
my $height = 400;

SDL_Init(VIDEO);

my $window = SDL_CreateWindow(
    'Pendulum - Perl 6',
    SDL_WINDOWPOS_CENTERED_MASK,
    SDL_WINDOWPOS_CENTERED_MASK,
    $width, $height, RESIZABLE
);

my $render = SDL_CreateRenderer($window, -1, ACCELERATED +| PRESENTVSYNC);

my $bob = Cairo::Image.create( Cairo::FORMAT_ARGB32, 32, 32 );
given Cairo::Context.new($bob) {
     my Cairo::Pattern::Gradient::Radial $sphere .=
        create(13.3, 12.8, 3.2, 12.8, 12.8, 32);
     $sphere.add_color_stop_rgba(0, 1, 1, .698, 1);
     $sphere.add_color_stop_rgba(1, .623, .669, .144, 1);
     .pattern($sphere);
     .arc(16, 16, 15, 0, 2 * pi);
     .fill;
     $sphere.destroy;
}

my $bob_texture = SDL_CreateTexture(
    $render, %PIXELFORMAT<ARGB8888>,
    STATIC, 32, 32
);

SDL_UpdateTexture(
    $bob_texture,
    SDL_Rect.new(:x(0), :y(0), :w(32), :h(32)),
    $bob.data, $bob.stride // 32
);

SDL_SetTextureBlendMode($bob_texture, 1);

SDL_SetRenderDrawBlendMode($render, 1);

my $event = SDL_Event.new;

my $now = now;   # time
my $Θ   = -π/3;  # start angle
my $ppi = 500;   # scale
my $g   = -9.81; # accelaration of gravity
my $ax  = $width/2; # anchor x
my $ay  = 25;       # anchor y
my $len = $height - 75; # 'rope' length
my $vel; # velocity
my $dt;  # delta time

main: loop {
    while SDL_PollEvent($event) {
        my $casted_event = SDL_CastEvent($event);
        given $casted_event {
            when *.type == QUIT    { last main }
            when *.type == WINDOWEVENT {
                if .event == 5 {
                    $width  = .data1;
                    $height = .data2;
                    $ax = $width/2;
                    $len = $height - 75;
                }
            }
        }
    }

    $dt = now - $now;
    $now = now;
    $vel += $g / $len * sin($Θ) * $ppi * $dt;
    $Θ   += $vel * $dt;
    my $bx = $ax + sin($Θ) * $len;
    my $by = $ay + cos($Θ) * $len;

    SDL_SetRenderDrawColor($render, 255, 255, 255, 255);
    SDL_RenderDrawLine($render, |($ax, $ay, $bx, $by)».round);
    SDL_RenderCopy( $render, $bob_texture, Nil,
      SDL_Rect.new($bx - 16, $by - 16, 32, 32)
    );
    SDL_RenderPresent($render);
    SDL_SetRenderDrawColor($render, 0, 0, 0, 0);
    SDL_RenderClear($render);
}

SDL_Quit();
