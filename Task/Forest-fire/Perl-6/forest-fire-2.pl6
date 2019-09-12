use NativeCall;
use SDL2::Raw;

my ($width, $height) = 900, 900;

SDL_Init(VIDEO);
my SDL_Window $window = SDL_CreateWindow(
    "Forest Fire - Perl 6",
    SDL_WINDOWPOS_CENTERED_MASK, SDL_WINDOWPOS_CENTERED_MASK,
    $width, $height,
    RESIZABLE
);
my SDL_Renderer $renderer = SDL_CreateRenderer( $window, -1, ACCELERATED +| PRESENTVSYNC );

SDL_ClearError();

my int ($w, $h) = 200, 200;

my $forest_texture = SDL_CreateTexture($renderer, %PIXELFORMAT<RGB332>, STREAMING, $w, $h);

my $pixdatabuf  = CArray[int64].new(0, $w, $h, $w);
my $work-buffer = CArray[int64].new(0, $w, $h, $w);

my int $bare    = 0;    # Black
my int $tree    = 8;    # Green
my int $heating = -120; # Orange ( 132 but it's being passed into an int8 )
my int $burning = 128;  # Red
my int $buf = $w * $h;
my $humidity    = .7;  # Chance that a tree next to a burning tree will resist catching fire
my $tree-spawn  = .75; # Initial probability that a space will contain a tree. Probability
                       # will be adjusted (way down) once rendering starts.

sub render {

    # work-around to pass the pointer-pointer.
    my $pixdata = nativecast(Pointer[int64], $pixdatabuf);
    SDL_LockTexture($forest_texture, SDL_Rect, $pixdata, my int $pitch);

    $pixdata = nativecast(CArray[int8], Pointer.new($pixdatabuf[0]));

    loop (my int $row; $row < $h; $row = $row + 1) {
        my int $rs = $row * $w; # row start
        my int $re = $rs  + $w; # row end
        loop (my int $idx = $rs; $idx < $re; $idx = $idx + 1) {
            # Skip it if it is a tree
            next if $pixdata[$idx] == $tree;
            if $pixdata[$idx] == $bare {
                # Maybe spawn a tree on bare ground
                $work-buffer[$idx] = rand < $tree-spawn ?? $tree !! $bare;
            } elsif $pixdata[$idx] == $heating {
                # Check if there are trees around a hot spot and light them if humidity is low enough
                $work-buffer[$idx - $w - 1] = $heating if rand > $humidity && $pixdata[$idx - $w - 1] && $row > 0;
                $work-buffer[$idx - $w    ] = $heating if rand > $humidity && $pixdata[$idx - $w    ] && $row > 0;
                $work-buffer[$idx - $w + 1] = $heating if rand > $humidity && $pixdata[$idx - $w + 1] && $row > 0;
                $work-buffer[$idx - 1     ] = $heating if rand > $humidity && $pixdata[$idx -  1    ];
                $work-buffer[$idx + $w - 1] = $heating if rand > $humidity && $pixdata[$idx + $w - 1];
                $work-buffer[$idx + $w    ] = $heating if rand > $humidity && $pixdata[$idx + $w    ];
                $work-buffer[$idx + $w + 1] = $heating if rand > $humidity && $pixdata[$idx + $w + 1];
                $work-buffer[$idx + 1     ] = $heating if rand > $humidity && $pixdata[$idx +  1    ];

                # Hotspot becomes a flame
                $work-buffer[$idx] = $burning
            } else {
                # Extinguish a flame after fuel is gone
                $work-buffer[$idx] = $bare;
            }
        }
    }
    # copy working buffer to main texture buffer
    loop (my int $i; $i < $buf; $i = $i + 1) { $pixdata[$i] = $work-buffer[$i] }

    # start a fire maybe
    $pixdata[$buf.rand] = $heating if rand < .1;

    SDL_UnlockTexture($forest_texture);

    SDL_RenderCopy($renderer, $forest_texture, SDL_Rect, SDL_Rect.new(:x(0), :y(0), :w($width), :h($height)));
    SDL_RenderPresent($renderer);
    once $tree-spawn = .005;
}

my $event = SDL_Event.new;

enum KEY_CODES ( K_Q => 20 );

main: loop {

    while SDL_PollEvent($event) {
        my $casted_event = SDL_CastEvent($event);

        given $casted_event {
            when *.type == QUIT {
                last main;
            }
            when *.type == KEYDOWN {
                if KEY_CODES(.scancode) -> $comm {
                    given $comm {
                        when 'K_Q'      { last main }
                    }
                }
            }
            when *.type == WINDOWEVENT {
                if .event == RESIZED {
                    $width  = .data1;
                    $height = .data2;
                }
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
