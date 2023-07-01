use NativeCall;
use SDL2::Raw;

my ($width, $height) = 900, 900;

unit sub MAIN ($stack = 10000);

my int ($w, $h) = 160, 160;

my $buf = $w * $h;
my @buffer = 0 xx $buf;

@buffer[$w * ($h div 2) + ($w div 2) - 1] = $stack;


SDL_Init(VIDEO);

my SDL_Window $window = SDL_CreateWindow(
    "Abelian sandpile - Raku",
    SDL_WINDOWPOS_CENTERED_MASK, SDL_WINDOWPOS_CENTERED_MASK,
    $width, $height,
    RESIZABLE
);

my SDL_Renderer $renderer = SDL_CreateRenderer( $window, -1, ACCELERATED +| TARGETTEXTURE );

my $asp_texture = SDL_CreateTexture($renderer, %PIXELFORMAT<RGB332>, STREAMING, $w, $h);

my $pixdatabuf = CArray[int64].new(0, $w, $h, $w);

my @color = 0x00, 0xDE, 0x14, 0xAA, 0xFF;

sub render {
    my int $pitch;
    my int $cursor;

    # work-around to pass the pointer-pointer.
    my $pixdata = nativecast(Pointer[int64], $pixdatabuf);
    SDL_LockTexture($asp_texture, SDL_Rect, $pixdata, $pitch);

    $pixdata = nativecast(CArray[int8], Pointer.new($pixdatabuf[0]));

    loop (my int $row; $row < $h; $row = $row + 1) {
        my int $rs = $row * $w; # row start
        my int $re = $rs  + $w; # row end
        loop (my int $idx = $rs; $idx < $re; $idx = $idx + 1) {
            $pixdata[$idx] =  @buffer[$idx] < 4 ?? @color[@buffer[$idx]] !! @color[4];
            if @buffer[$idx] >= 4 {
                my $grains = floor @buffer[$idx] / 4;
                @buffer[ $idx - $w ] += $grains if $row > 0;
                @buffer[ $idx - 1  ] += $grains if $idx - 1 >= $rs;
                @buffer[ $idx + $w ] += $grains if $row < $h - 1;
                @buffer[ $idx + 1  ] += $grains if $idx + 1 < $re;
                @buffer[ $idx ] %= 4;
            }
        }
    }

    SDL_UnlockTexture($asp_texture);

    SDL_RenderCopy($renderer, $asp_texture, SDL_Rect, SDL_Rect.new(:x(0), :y(0), :w($width), :h($height)));
    SDL_RenderPresent($renderer);
}

my $event = SDL_Event.new;

main: loop {

    while SDL_PollEvent($event) {
        my $casted_event = SDL_CastEvent($event);

        given $casted_event {
            when *.type == QUIT {
                last main;
            }
        }
    }

    render();
    print fps;
}

say '';

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
