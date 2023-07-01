(defun draw-coords-as-text (coords size fill-char)
  (let* ((min-x (apply #'min (mapcar #'car coords)))
         (min-y (apply #'min (mapcar #'cdr coords)))
         (max-x (apply #'max (mapcar #'car coords)))
         (max-y (apply #'max (mapcar #'cdr coords)))
         (real-size (max (+ (abs min-x) (abs max-x)) ; bounding square
                         (+ (abs min-y) (abs max-y))))
         (scale-factor (* (1- size) (/ 1 real-size)))
         (center-x (* scale-factor -1 min-x))
         (center-y (* scale-factor -1 min-y))
         (intermediate-result (make-array (list size size)
                                          :element-type 'char
                                          :initial-element #\space)))
    (dolist (c coords)
      (let ((final-x (floor (+ center-x (* scale-factor (car c)))))
            (final-y (floor (+ center-y (* scale-factor (cdr c))))))
        (setf (aref intermediate-result final-x final-y)
              fill-char)))
    ; print results to output
    (loop for i below (array-total-size intermediate-result) do
          (when (zerop (mod i size))
            (terpri))
          (princ (row-major-aref intermediate-result i)))))


(defun spiral (a b step-resolution step-count)
  "Returns a list of coordinates for r=a+b*theta stepping theta by step-resolution"
  (loop for theta
        from 0 upto (* step-count step-resolution)
        by step-resolution
        for r = (+ a (* b theta))
        for x = (* r (cos theta))
        for y = (* r (sin theta))
        collect (cons x y)))

(draw-coords-as-text (spiral 10 10 0.01 1500) 30 #\*)
; Output:
;
;                         *
;          ******          *
;       ****    ***        **
;     ***          **       *
;    **             **       *
;   **               **      *
;   *                 **     **
;  **                  *      *
; **       ******      *      *
; *       **    **     **     *
; *      **      *      *     *
; *     **       *      *     **
; *     *        *      *     *
; *     *     * **      *     *
; *     *     ***      **     *
; *     **             *      *
; *      *            **      *
; *      **          **      **
; **      **        **       *
;  *       **      **       **
;  **       ********        *
;   *                      **
;   **                    **
;    **                  **
;     **               ***
;       **            **
;        ****      ***
;           *******
;
