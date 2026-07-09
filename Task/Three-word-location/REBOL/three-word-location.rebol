Rebol [
    title: "Rosetta code: Three word location"
    file:  %Three_word_location.r3
    url:   https://rosettacode.org/wiki/Three_word_location
]

w3w-encode: func [
    "Encodes an integer as a W-prefixed 5-digit word"
    w [integer!]
][
    ajoin ["W" pad/with w -5 #"0"]
]
w3w-decode: func [
    "Decodes a W-prefixed word back to an integer"
    ws [string!]
][
    to integer! skip ws 1
]

latlon-to-words: function [
    "Encodes a lat/lon coordinate pair into three W-prefixed words"
    lat [decimal!] lon [decimal!]
][
    ilat: to integer! lat * 10000 + 900000  ;; shift to positive range 0..1800000
    ilon: to integer! lon * 10000 + 1800000 ;; shift to positive range 0..3600000
    latlon: (ilat << 22) + ilon             ;; pack into a single 43-bit integer
    w1:   (latlon >> 28) & 0#7FFF           ;; bits 42-28 (15 bits)
    w2:   (latlon >> 14) & 0#3FFF           ;; bits 27-14 (14 bits)
    w3:    latlon        & 0#3FFF           ;; bits 13-0  (14 bits)
    reduce [w3w-encode w1  w3w-encode w2  w3w-encode w3]
]

words-to-latlon: function [
    "Decodes three W-prefixed words back into a lat/lon coordinate pair"
    w1s [string!] w2s [string!] w3s [string!]
][
    latlon: ((w3w-decode w1s) << 28) | ((w3w-decode w2s) << 14) | w3w-decode w3s
    ilat: latlon >> 22
    ilon: latlon & 0#3FFFFF
    reduce [
        ilat - 900000  / 10000.0
        ilon - 1800000 / 10000.0
    ]
]

;; --- main ---

lat:  28.3852
lon: -81.5638

print as-yellow "Starting figures:"
print [" latitude =" round/to lat 0.0001 " longitude =" round/to lon 0.0001]

set [w1s w2s w3s] latlon-to-words lat lon
print as-yellow "^/Three word location is:"
print ["" w1s w2s w3s]

set [lat lon] words-to-latlon w1s w2s w3s
print as-yellow "^/After reversing the procedure:"
print [" latitude =" round/to lat 0.0001 " longitude =" round/to lon 0.0001]
