(setq startVal 32)
(setq endVal 127)
(setq cols 6)

(defun print-val (val) "Prints the value for that ascii number"
	(cond
		((= val 32) (format t " 32: SPC "))
		((= val 127) (format t "127: DEL~%"))
		((and (zerop (mod (- val startVal) cols)) (< val 100)) (format t "~% ~d: ~a   " val (int-char val)))
		((and (zerop (mod (- val startVal) cols)) (>= val 100)) (format t "~%~d: ~a   " val (int-char val)))
		((< val 100) (format t " ~d:  ~a   " val (int-char val)))
		((>= val 100) (format t "~d:  ~a   " val (int-char val)))
		(t nil)))

        (defun get-range (lower upper) "Returns a list of range lower to upper"
	(if (> lower upper) '() (cons lower (get-range (+ 1 lower) upper))))

(mapcar #'print-val (get-range startVal endVal))
