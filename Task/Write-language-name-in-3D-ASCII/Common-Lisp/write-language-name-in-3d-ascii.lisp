(ql:quickload :cl-ppcre)
(defvar txt
"
 xxxx    xxxx   x    x  x    x   xxxx   x    x       x      x   xxxx   xxxxx
x    x  x    x  xx  xx  xx  xx  x    x  xx   x       x         x    x  x    x
x       x    x  x xx x  x xx x  x    x  x x  x       x      x  xxx     x    x
x       x    x  x    x  x    x  x    x  x  x x       x      x     xxx  xxxxx
x    x  x    x  x    x  x    x  x    x  x   xx       x      x  x    x  x
 xxxx    xxxx   x    x  x    x   xxxx   x    x       xxxxx  x   xxxx   x
"
)
(princ (cl-ppcre:regex-replace-all " " (cl-ppcre:regex-replace-all "x" txt "_/") "  " ))
