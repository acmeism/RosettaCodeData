CL-USER> (pancake-sort '(6 7 8 9 2 5 3 4 1))  ;list
(1 2 3 4 5 6 7 8 9)
CL-USER> (pancake-sort #(6 7 8 9 2 5 3 4 1))  ;array
#(1 2 3 4 5 6 7 8 9)
CL-USER> (pancake-sort #(6.5 7.5 8 9 2 5 3 4 1.0))  ;array with integer and floating point values
#(1.0 2 3 4 5 6.5 7.5 8 9)
