Rebol [
  title: "Rosetta code: Bitmap/Histogram"
  file:  %Bitmap-Histogram.r3
  url:   https://rosettacode.org/wiki/Bitmap/Bitmap-Histogram
  needs: 3.21.9
]

;; Load source image from file
img: load %Lenna50.jpg
;; Extract luminosity as vector for statistical operations
vec: to vector! img/luminosity
;; Compute median brightness threshold
med: vec/median
;; Allocate 256-bucket uint32 histogram (one bucket per brightness level)
histogram: make vector! [uint32! 255]
;; In a single pass: build brightness histogram and threshold each pixel
forall vec [
    val: vec/1
    histogram/:val: histogram/:val + 1  ;; tally pixel's brightness bucket
    vec/1: either val < med [0][255]    ;; binarize: black or white
]
;; Inspect histogram distribution
? histogram
;; Write thresholded grayscale data back to image
img/gray: vec
;; Save result as PNG and open in browser
browse save %Lenna50-bw.png img
