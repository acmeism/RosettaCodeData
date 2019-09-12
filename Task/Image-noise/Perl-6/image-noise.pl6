use NativeCall;
use SDL2::Raw;

my int ($w, $h) = 320, 240;

SDL_Init(VIDEO);

my SDL_Window $window = SDL_CreateWindow(
    "White Noise - Perl 6",
    SDL_WINDOWPOS_CENTERED_MASK, SDL_WINDOWPOS_CENTERED_MASK,
    $w, $h,
    RESIZABLE
);

my SDL_Renderer $renderer = SDL_CreateRenderer( $window, -1, ACCELERATED +| TARGETTEXTURE );

my $noise_texture = SDL_CreateTexture($renderer, %PIXELFORMAT<RGB332>, STREAMING, $w, $h);

my $pixdatabuf = CArray[int64].new(0, $w, $h, $w);

sub render {
    my int $pitch;
    my int $cursor;

    # work-around to pass the pointer-pointer.
    my $pixdata = nativecast(Pointer[int64], $pixdatabuf);
    SDL_LockTexture($noise_texture, SDL_Rect, $pixdata, $pitch);

    $pixdata = nativecast(CArray[int8], Pointer.new($pixdatabuf[0]));

    loop (my int $row; $row < $h; $row = $row + 1) {
        loop (my int $col; $col < $w; $col = $col + 1) {
            $pixdata[$cursor + $col] = Bool.roll ?? 0xff !! 0x0;
        }
        $cursor = $cursor + $pitch;
    }

    SDL_UnlockTexture($noise_texture);

    SDL_RenderCopy($renderer, $noise_texture, SDL_Rect, SDL_Rect);
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
