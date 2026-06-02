Rebol [
    title: "Rosetta code: Color quantization (Median cut)"
    file:  %Color_quantization-median_cut.r3
    url:   https://rosettacode.org/wiki/Color_quantization
]

median-cut: function [
    "Reduces image to N colors using the median cut algorithm"
    img [image! file! url!] "Source image to quantize (modified)"
    n-colors [integer!] "Number of requested colors"
][
    unless image? img [img: load img]
    colors: make block! n-colors

    ;; Build a flat bucket block [clr1 idx1 clr2 idx2 ...]
    ;; where each clr is a tuple! and idx is the pixel's position in the image
    bucket: make block! img/size/x * img/size/y
    idx: 1 foreach clr img [ repend bucket [clr ++ idx] ]
    ;; Pre-sort once — all buckets remain sorted after every split
    sort/skip bucket 2
    ;; Start with one bucket containing all pixels
    buckets: reduce [bucket]
    ;; Keep splitting until we have enough buckets for the requested color count
    while [n-colors > length? buckets] [
        ;; Take the first bucket (always the largest due to append order)
        bucket: take buckets
        ;; Split at the upper median to ensure the most even division of pairs
        med: 2 * round/ceiling (length? bucket) / 2 / 2
        ;; Append the upper median and the remainder back as two new buckets
        append/only buckets take/part bucket med
        append/only buckets bucket
    ]
    ;; Quantize each bucket
    foreach bucket buckets [
        ;; Averages all colors in a bucket
        r-sum: 0  g-sum: 0  b-sum: 0
        foreach [clr idx] bucket [
            r-sum: r-sum + clr/1
            g-sum: g-sum + clr/2
            b-sum: b-sum + clr/3
        ]
        n: 0.5 * length? bucket  ;; number of colors in the bucket
        mean-color: to tuple! reduce [
            r-sum / n
            g-sum / n
            b-sum / n
        ]
        ;; Write the mean color back to every pixel in this bucket
        foreach [clr idx] bucket [ img/:idx: mean-color ]
        ;; Keep the mean color
        append colors mean-color
    ]
    ;; Return image and colors
    reduce [img colors]
]

;; Download the original image if does not exists.
unless exists? %Quantum_frog.png [
    write %quantum_frog.png
     read https://static.wikitide.net/rosettacodewiki/3/3f/Quantum_frog.png
]
foreach [colors output-name] [
    16 %Quantum_frog-16-colors.png
     3 %Quantum_frog-3-colors.png
][
    ;; Quantize to N colors
    time: delta-time [
        set [img colors] median-cut %Quantum_frog.png colors
    ]
    print ["Time to compute:" time]
    ;; Display all used colors
    print ["The" length? colors "colors:"]
    probe new-line/all colors true
    save output-name img  ;; Save the result
    browse output-name    ;; Display the image in a browser
]
