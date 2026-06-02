Rebol [
    title: "Rosetta code: Draw a pixel"
    file:  %Draw_a_pixel.r3
    url:   https://rosettacode.org/wiki/Draw_a_pixel
]

img: make image! 320x240 ;; Create a new image of size 320x240 pixels
img/(100x100): 255.0.0   ;; Set the pixel at position 100x100 to pure red
save %test.png img       ;; Save the image to a PNG file named "test.png"
browse %test.png         ;; Open the saved image file using the default browser
