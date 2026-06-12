;; Load the alexandria library from the quicklisp repository
CL-USER> (ql:quickload "alexandria")

CL-USER> (alexandria:rotate '(1 2 3 4 5 6 7 8 9) -3)
(4 5 6 7 8 9 1 2 3)
