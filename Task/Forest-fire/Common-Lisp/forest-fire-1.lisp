(defvar *dims* '(10 10))
(defvar *prob-t* 0.5)
(defvar *prob-f* 0.1)
(defvar *prob-p* 0.01)

(defmacro with-gensyms (names &body body)
  `(let ,(mapcar (lambda (n) (list n '(gensym))) names)
	 ,@body))
	
(defmacro traverse-grid (grid rowvar colvar (&rest after-cols) &body body)
  (with-gensyms (dims rows cols)
	`(let* ((,dims (array-dimensions ,grid))
		(,rows (car ,dims))
		(,cols (cadr ,dims)))
	   (dotimes (,rowvar ,rows ,grid)
		 (dotimes (,colvar ,cols ,after-cols)
		   ,@body)))))

(defun make-new-forest (&optional (dims *dims*))
  (let ((forest (make-array dims :element-type 'symbol :initial-element 'void)))
	(traverse-grid forest row col nil
	  (if (<= (random 1.0) *prob-t*)
		  (setf (aref forest row col) 'tree)))))

(defun print-forest (forest)
  (traverse-grid forest row col (terpri)
	(ecase (aref forest row col)
	  ((void) (write-char #\space))
	  ((tree) (write-char #\T))
	  ((fire) (write-char #\#))))
  (values))

(defvar *neighboring* '((-1 . -1) (-1 . 0) (-1 . 1)
			(0 . -1)           (0 . 1)
			(1 . -1)  (1 . 0)  (1 . 1)))

(defun neighbors (forest row col)
  (loop for n in *neighboring*
	for nrow = (+ row (car n))
        for ncol = (+ col (cdr n))
	when (array-in-bounds-p forest nrow ncol)
	collect (aref forest nrow ncol)))

(defun evolve-tree (forest row col)
  (let ((tree (aref forest row col)))
	(cond ((eq tree 'fire) ;; if the tree was on fire, it's dead Jim
		   'void)
	      ((and (eq tree 'tree) ;; if a neighbor is on fire, it's on fire too
		    (find 'fire (neighbors forest row col) :test #'eq))
		   'fire)
	      ((and (eq tree 'tree) ;; random chance of fire happening
		    (<= (random 1.0) *prob-f*))
		   'fire)
	      ((and (eq tree 'void) ;; random chance of empty space becoming a tree
		    (<= (random 1.0) *prob-p*))
		   'tree)
		  (t tree))))

(defun evolve-forest (forest)
  (let* ((dims (array-dimensions forest))
	 (new (make-array dims :element-type 'symbol :initial-element 'void)))
	(traverse-grid forest row col nil
	  (setf (aref new row col) (evolve-tree forest row col)))
	new))

(defun simulate (forest n &optional (print-all t))
  (format t "------ Initial forest ------~%")
  (print-forest forest)
  (dotimes (i n)
    (setf forest (evolve-forest forest))
    (when print-all
      (progn (format t "~%------ Generation ~d ------~%" (1+ i))
 	(print-forest forest)))))
