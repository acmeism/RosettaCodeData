Rebol [
   title: "Rosetta code: Bitmap/Write a PPM file"
   file:  %Bitmap-Write_a_PPM_file.r3
   url:   https://rosettacode.org/wiki/Bitmap/Write_a_PPM_file
]

to-ppm: function [
    "Converts an image to a PPM (Portable Pixmap) format string"
    ;; This function is using padding in the output.
    ;; In the real life usage it could be removed.
    img [image!]
][
    ;; Extract image dimensions as integers
    wide: to integer! img/size/x
    high: to integer! img/size/y

    ;; Build the PPM header:
    ;;   P3 = plain RGB text format
    ;;   wide/high = pixel dimensions
    ;;   255 = max color value (8-bit per channel)
    out: rejoin ["P3^/" wide SP high "^/255^/"]

    ;; Iterate over every pixel in the image
    n: 0  ;; Pixel counter, used to detect end of each row
    foreach clr img [
        ++ n
        ;; Append R, G, B channel values, right-aligned in fixed-width columns
        ;; pad ... -5/-4 = right-align in field of 5 or 4 characters
        append out ajoin [
            pad clr/1 -5 ;R
            pad clr/2 -4 ;G
            pad clr/3 -4 ;B
            ;; After the last pixel in each row, insert a newline
            if zero? n % wide [ newline ]
        ]
    ]
    out
]

; --- Demo ---
; Create a 2x2 image and set pixels 1 (top-left) and 4 (bottom-right) to black
img: make image! 2x2
img/1: img/4: black
print to-ppm img

;; It is also possible to register a PPM codec
register-codec [
    name:  'ppm
    type:  'image
    title: "Portable Pixmap (PPM) File Format"
    suffixes: [%.ppm]
    encode: :to-ppm
]
;; Then use it as:
ppm-data: encode 'ppm img
;; or
save %image.ppm img
