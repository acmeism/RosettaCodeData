USING: kernel random raylib.ffi ;

640 480 2dup "random yellow pixel" init-window [ random ] bi@

60 set-target-fps [ window-should-close ] [
    begin-drawing BLACK clear-background 2dup YELLOW draw-pixel
    end-drawing
] until close-window
