(in-package :cg-user)

;;; We only need a bitmap pane - nothing fancy
(defclass draw-pane (bitmap-pane)())

;;; close it down by clicking on it
(defmethod mouse-left-down ((pane draw-pane) buttons data)
  (declare (ignore buttons data))
  (close pane))

;;; Create the window and draw the pinstripes
(defun make-draw-window ()
  (let ((win (make-window :one :class 'draw-pane :width 300 :height 200)))
    (draw win)))

;;; Function to draw the pinstripes.  The lines are a bit ragged at the intersections
;;; between pinstripe sections due to the fact that common graphics uses round line
;;; caps and there doesn't appear any way to change that.  Could be fixed by using
;;; rectangles rather than lines or, perhaps, by setting rectangular clipping regions.

(defun draw (win)
  (do ((lwidth 1 (+ 1 lwidth))
       (top 0 bottom)
       (colors (make-array 8 :initial-contents
                           '(black red green blue magenta cyan yellow white)))
       (bottom (/ (height win) 4) (+ (/ (height win) 4) bottom)))
      ((eql 5 lwidth) t)
    (with-line-width (win lwidth)
      (do ((xpos 0 (+ xpos lwidth))
           (clr-ndx 0 (mod (+ clr-ndx 1) 8)))
           ((> xpos (width win)) t)
        (with-foreground-color (win (aref colors clr-ndx))
          (draw-line win
                     (make-position xpos top)
                     (make-position xpos bottom)))))))
