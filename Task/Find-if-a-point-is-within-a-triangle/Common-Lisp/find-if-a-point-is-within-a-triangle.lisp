; There are different algorithms to solve this problem, such as adding areas, adding angles, etc... but these
; solutions are sensitive to rounding errors intrinsic to float operations. We want to avoid these issues, therefore we
; use the following algorithm which only uses multiplication and subtraction: we consider one side of the triangle
; and see on which side of it is the point P located. We can give +1 if it is on the right hand side, -1 for the
; left side, or 0 if it is on the line. If the point is located on the same side relative to all three sides of the triangle
; then the point is inside of it. This has an added advantage that it can be scaled up to other more complicated figures
; (even concave ones, with some minor modifications).

(defun point-inside-triangle (P A B C)
"Is the point P inside the triangle formed by ABC?"
  (= (side-of-line P A B)
     (side-of-line P B C)
     (side-of-line P C A) ))


; This is the version to include those points which are on one of the sides
(defun point-inside-or-on-triangle (P A B C)
"Is the point P inside the triangle formed by ABC or on one of the sides?"
  (apply #'= (remove 0 (list (side-of-line P A B) (side-of-line P B C) (side-of-line P C A)))) )


(defun side-of-line (P A B)
"Return +1 if it is on the right side, -1 for the left side, or 0 if it is on the line"
; We use the sign of the determinant of vectors (AB,AM), where M(X,Y) is the query point:
; position = sign((Bx - Ax) * (Y - Ay) - (By - Ay) * (X - Ax))
(signum (- (* (- (car B) (car A))
              (- (cdr P) (cdr A)) )
           (* (- (cdr B) (cdr A))
              (- (car P) (car A)) ))))
