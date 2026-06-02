Rebol [
    title: "Rosetta code: Bitmap/Flood fill"
    file:  %Bitmap-Flood_fill.r3
    url:   https://rosettacode.org/wiki/Bitmap/Bitmap-Flood_fill
]

flood-fill: function [
    image     [image! file! url!]
    position  [pair!]  "Start position"
    color1    [tuple!] "Target color to replace"
    color2    [tuple!] "Replacement color"
][
    unless image? image [image: load image] ;; Load image if not already loaded
    xsize: image/size/x
    ysize: image/size/y

    color2/4: color1/4: 255  ;; Ensure both colors are fully opaque

    que: copy []
    if image/:position != color1 [return image] ;; Bail if seed pixel isn't target color

    append que position
    while [not empty? que][
        position: take que              ;; Dequeue next position to process
        if image/:position == color1 [  ;; Skip if already recolored
            W: position
            ;; Scan west, recoloring pixels until we leave the target-color region
            while [image/:W == color1][
                image/:W: color2
                next: W + 0x1           ;; Pixel south of W
                if all [next/y < ysize color1 == image/:next][append que next]
                next: W - 0x1           ;; Pixel north of W
                if all [next/y > 0     color1 == image/:next][append que next]
                next: W - 1x0           ;; Step west
                either next/x > 1 [W: next][break] ;; Stop at left edge
            ]
            E: position + 1x0           ;; Start east scan one step right of seed
            if E/x < xsize [
                ;; Scan east, recoloring pixels until we leave the target-color region
                while [image/:E == color1][
                    image/:E: color2
                    next: E + 0x1       ;; Pixel south of E
                    if all [next/y < ysize color1 == image/:next][append que next]
                    next: E - 0x1       ;; Pixel north of E
                    if all [next/y > 0     color1 == image/:next][append que next]
                    next: E + 1x0       ;; Step east
                    either next/x < xsize [E: next][break] ;; Stop at right edge
                ]
            ]
        ]
    ]
    image   ;; Return the modified image
]

;; Download the test image if not already cached locally
unless exists? file: %Unfilledcirc.png [
    write file read https://static.wikitide.net/rosettacodewiki/0/0f/Unfilledcirc.png
]

img: load %Unfilledcirc.png
img: flood-fill img 200x200 white red
img: flood-fill img 100x100 black blue

browse save %Filledcirc.png img        ;; Save result and open in browser
