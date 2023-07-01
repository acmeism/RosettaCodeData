USING: accessors arrays images images.testing images.viewer
kernel literals math sequences ;
IN: rosetta-code.draw-pixel

: draw-pixel ( -- )
    B{ 255 0 0 } 100 100 <rgb-image> 320 240 [ 2array >>dim ]
    [ * ] 2bi [ { 0 0 0 } ] replicate B{ } concat-as >>bitmap
    [ set-pixel-at ] keep image-window ;

MAIN: draw-pixel
