; Makes an array of 20 objects initialized to nil
(make-array 20 :initial-element nil)
; Makes an integer array of 4 elements containing 1 2 3 and 4 initially which can be resized
(make-array 4 :element-type 'integer :initial-contents '(1 2 3 4) :adjustable t)
