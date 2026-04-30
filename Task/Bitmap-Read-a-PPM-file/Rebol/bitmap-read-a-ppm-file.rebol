Rebol [
  title: "Rosetta code: Bitmap/Read a PPM file"
  file:  %Bitmap-Read_a_PPM_file.r3
  url:   https://rosettacode.org/wiki/Bitmap/Read_a_PPM_file
]

decode-ppm: function[ppm [string! file! url!]][
    ;; Load source into a string if a file or URL was given
    unless string? ppm [ppm: read/string ppm]
    if all [
        ;; Strip the "P3" magic header and any comment lines
        parse/case ppm ["P3" any [LF | #"#" to LF skip] ppm: to end]
        ;; Lex the remaining text into Rebol values
        try [ppm: transcode ppm]
        ;; Extract image dimensions, colour depth, and raw RGB values
        parse ppm [
            set width:  integer!
            set height: integer!
            set depth:  integer!
            rgb: to end
        ]
    ][
        img: make image! as-pair width height
        i: 1 clr: 0.0.0
        foreach [r g b] rgb [
            ;; Normalise each channel to 0–255
            clr/1: 255 * (r / depth)
            clr/2: 255 * (g / depth)
            clr/3: 255 * (b / depth)
            img/:i: clr
            ++ i
        ]
        ;; Return the completed image
        img
    ]
]

img: decode-ppm {P3
# feep.ppm
4 4
15
0  0  0    0  0  0    0  0  0   15  0 15
0  0  0    0 15  7    0  0  0    0  0  0
0  0  0    0  0  0    0 15  7    0  0  0
15  0 15    0  0  0    0  0  0    0  0  0}

print "Source image:"
print img
print "Grayscale PPM output:"
print to-ppm grayscale img ;@@ https://rosettacode.org/wiki/Bitmap/Write_a_PPM_file
