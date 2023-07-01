stoogesort := [:L :i :j |
     (L at:i) > (L at:j) ifTrue:[
         L swap:i with:j
     ].
     (j - i + 1) > 2 ifTrue:[
         t := ((j - i + 1) / 3) floor.
         stoogesort value:L value:i value:j-t.
         stoogesort value:L value:i+t value:j.
         stoogesort value:L value:i value:j-t.
     ].
].

a := #(1 4 5 3 -6 3 7 10 -2 -5 7 5 9 -3 7)  copy.
stoogesort value:a value:1 value:a size.
Transcript showCR:a
