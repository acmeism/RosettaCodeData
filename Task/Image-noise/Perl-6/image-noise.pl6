use NativeCall;
use SDL2::Raw;
use nqp;

my int ($w, $h) = 320, 240;
my SDL_Window $window;
my SDL_Renderer $renderer;

constant $sdl-lib = 'SDL2';

sub SDL_RenderDrawPoints( SDL_Renderer $, CArray[int32] $points, int32 $count ) returns int32 is native($sdl-lib) {*}

SDL_Init(VIDEO);
$window = SDL_CreateWindow(
    "some white noise",
    SDL_WINDOWPOS_CENTERED_MASK, SDL_WINDOWPOS_CENTERED_MASK,
    $w, $h,
    SHOWN
);
$renderer = SDL_CreateRenderer( $window, -1, ACCELERATED +| TARGETTEXTURE );

SDL_ClearError();

my $noise_texture = SDL_CreateTexture($renderer, %PIXELFORMAT<RGB332>, STREAMING, $w, $h);

my $pixdatabuf = CArray[int64].new(0, 1234, 1234, 1234);

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

my @times;

main: loop {
    my $start = nqp::time_n();

    while SDL_PollEvent($event) {
        my $casted_event = SDL_CastEvent($event);

        given $casted_event {
            when *.type == QUIT {
                last main;
            }
        }
    }

    render();

    @times.push: nqp::time_n() - $start;
}

@times .= sort;

my @timings = (@times[* div 50], @times[* div 4], @times[* div 2], @times[* * 3 div 4], @times[* - * div 100]);

say "frames per second:";
say (1 X/ @timings).fmt("%3.4f");
