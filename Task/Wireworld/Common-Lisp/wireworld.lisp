(defun electron-neighbors (wireworld row col)
  (destructuring-bind (rows cols) (array-dimensions wireworld)
    (loop   for off-row from (max 0 (1- row)) to (min (1- rows) (1+ row)) sum
      (loop for off-col from (max 0 (1- col)) to (min (1- cols) (1+ col)) count
        (and (not (and (= off-row row) (= off-col col)))
             (eq 'electron-head (aref wireworld off-row off-col)))))))

(defun wireworld-next-generation (wireworld)
  (destructuring-bind (rows cols) (array-dimensions wireworld)
    (let ((backing (make-array (list rows cols))))
      (do ((c 0 (if (= c (1- cols)) 0 (1+ c)))
           (r 0 (if (= c (1- cols)) (1+ r) r)))
          ((= r rows))
        (setf (aref backing r c) (aref wireworld r c)))
      (do ((c 0 (if (= c (1- cols)) 0 (1+ c)))
           (r 0 (if (= c (1- cols)) (1+ r) r)))
          ((= r rows))
        (setf (aref wireworld r c)
              (case (aref backing r c)
                (electron-head 'electron-tail)
                (electron-tail 'conductor)
                (conductor (case (electron-neighbors backing r c)
                             ((1 2) 'electron-head)
                             (otherwise 'conductor)))
                (otherwise nil)))))))

(defun print-wireworld (wireworld)
  (destructuring-bind (rows cols) (array-dimensions wireworld)
    (do ((r 0 (1+ r)))
        ((= r rows))
      (do ((c 0 (1+ c)))
          ((= c cols))
        (format t "~C" (case (aref wireworld r c)
                         (electron-head #\H)
                         (electron-tail #\t)
                         (conductor #\.)
                         (otherwise #\Space))))
      (format t "~&"))))

(defun wireworld-show-gens (wireworld n)
  (dotimes (m n)
    (terpri)
    (wireworld-next-generation wireworld)
    (print-wireworld wireworld)))

(defun ww-char-to-symbol (char)
  (ecase char
    (#\Space 'nil)
    (#\.     'conductor)
    (#\t     'electron-tail)
    (#\H     'electron-head)))

(defun make-wireworld (image)
  "Make a wireworld grid from a list of strings (rows) of equal length
(columns), each character being ' ', '.', 'H', or 't'."
  (make-array (list (length image) (length (first image)))
              :initial-contents
              (mapcar (lambda (s) (map 'list #'ww-char-to-symbol s)) image)))

(defun make-rosetta-wireworld ()
  (make-wireworld '("tH........."
                    ".   .      "
                    "   ...     "
                    ".   .      "
                    "Ht.. ......")))
