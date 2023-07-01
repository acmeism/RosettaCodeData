(define flatten
[] -> []
[X|Y] -> (append (flatten X) (flatten Y))
X -> [X])

(flatten [[1] 2 [[3 4] 5] [[[]]] [[[6]]] 7 8 []])
