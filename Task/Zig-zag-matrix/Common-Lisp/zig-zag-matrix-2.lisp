; ZigZag
;
; Nigel Galloway.
; June 4th., 2012
;
(defun ZigZag (COLS)
  (let ((cs 2) (st '(1 2)) (dx '(-1 1)))
    (defun new_cx (i)
      (setq st (append st (list (setq cs (+ cs (* 2 i))) (setq cs (+ 1 cs))))
            dx (append dx '(-1 1))))
    (do ((i 2 (+ 2 i))) ((>= i COLS)) (new_cx i))
    (do ((i (- COLS 1 (mod COLS 2)) (+ -2 i))) ((<= i 0)) (new_cx i))
    (do ((i 0 (+ 1 i))) ((>= i COLS))
      (format t "~%")
      (do ((j i (+ 1 j))) ((>= j (+ COLS i)))
        (format t "~3d" (nth j st))
        (setf (nth j st) (+ (nth j st) (nth j dx)))))))
