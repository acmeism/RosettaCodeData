REBOL [
	Title: "Percent Image Difference"
	URL: http://rosettacode.org/wiki/Percentage_of_difference_between_2_images
]

; Load from local storage. Un/comment as preferred.
; a: load-image %lenna50.jpg
; b: load-image %lenna100.jpg

; Download from rosettacode.org.
a: load-image http://rosettacode.org/mw/images/3/3c/Lenna50.jpg
b: load-image http://rosettacode.org/mw/images/b/b6/Lenna100.jpg

if a/size <> b/size [print "Image dimensions must match."  halt]

; Compute difference. REBOL has built-in image processing as part of
; its GUI package that I can take advantage of here:

diff: to-image layout/tight [image a effect [difference b]]

; Calculate deviation. I use 'repeat' to rip through the image pixels
; (it knows how to deal with images) and sum, then average. Note that
; I can treat the image like an array to get number of pixels.

t: 0
repeat p diff [t: t + p/1 + p/2 + p/3]
print rejoin ["Difference: "  100 * t / (255 * 3 * length? diff)  "%"]

; Optional: Since I now have a difference image, I may as well show
; it. Use the buttons or keys 'a', 'b' and 'd' to switch between the
; various images.

flip: func [
	"Change to new image and label."
	name [word!] "Image to switch to."
][x/text: rejoin ["Image " name]  x/image: get name  show x]

; Because the differences between the images are very small, I enhance
; the diff with a high contrast to make the result easier to
; see. Comment this out for the "pure" image.

diff: to-image layout/tight [image diff effect [contrast 100]]

view l: layout [
	x: image diff
	across
	button "a" #"a"          [flip 'a]
	button "b" #"b"          [flip 'b]
	button "difference" #"d" [flip 'diff]
]
