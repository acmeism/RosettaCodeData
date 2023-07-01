(in-package :cg-user)

(defun print-hex (n)
  (let ((*print-base* 16.) (*print-radix* t))
    (print n)) t)

(defun get-byte (n byte)
  (logand (ash n (* byte -8)) #xFF))

(defun get-pixel (x y)
  (let ((pixval (caar (contents (get-screen-pixmap :box (make-box x y (+ x 1) (+ y 1)))))))
    (mapcar #'(lambda (i) (get-byte pixval i)) '(2 1 0 3))))

(defun get-mouse-pixel ()
  (let ((pos (cursor-position (screen *system*))))
    (get-pixel (position-x pos) (position-y pos))))

(print-hex (get-mouse-pixel))
