Rebol [
    title: "Rosetta code: Grayscale image"
    file:  %Grayscale_image.r3
    url:   https://rosettacode.org/wiki/Grayscale_image
]

unless exists? %Flowersfb.jpg [
    write %Flowersfb.jpg
     read https://static.wikitide.net/rosettacodewiki/7/78/Flowersfb.jpg
]

img:   load %Flowersfb.jpg      ;; Original image
gray1: grayscale  copy img      ;; Use Average method
gray2: luminosity copy img      ;; Use BT.709 luminosity formula
gray3: luminosity/luma copy img ;; Use BT.601 gamma-compressed values

save %Grayscale_image_average.png gray1
save %Grayscale_image_BT709.png  gray2
save %Grayscale_image_BT601.png  gray3
