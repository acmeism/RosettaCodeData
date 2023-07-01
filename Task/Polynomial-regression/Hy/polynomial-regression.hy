(import [numpy [polyfit]])

(setv x (range 11))
(setv y [1 6 17 34 57 86 121 162 209 262 321])

(print (polyfit x y 2))
