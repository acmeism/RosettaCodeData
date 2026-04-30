(defvar avl-all-nodes (make-vector 100 nil))
(defvar avl-root-node nil "root node")

(defun avl-create-node (key parent)
  (copy-tree `((:key . ,key) (:balance . nil) (:height . nil)
	       (:left . nil) (:right . nil) (:parent . ,parent))))

(defun avl-node (pos)
  (if (or (null pos) (> pos (1- (length avl-all-nodes))))
      nil
    (aref avl-all-nodes pos)))

(defun avl-node-prop (noderef &rest props)
  (if (null noderef)
      nil
    (progn
      ;;(when (integerp noderef) (setq node (avl-node node)))
      (let ((val noderef))
        (dolist (prop props)
          (if (null (avl-node val))
	      (setq val nil)
	    (progn
	      (setq val (alist-get prop (avl-node val))))))
        val)
      )
    )
  )


(defun avl-set-prop (node &rest props-and-value)
  (when (integerp node) (setq node (avl-node node)))
  (when (< (length props-and-value) 2)
    (error "Both property name and value must be given."))
  (let (noderef (props (seq-take props-and-value (1- (length props-and-value))))
                (value (seq-elt props-and-value (1- (length props-and-value)))))
    (when (> (length props) 0)
      (dolist (prop (seq-take props (1- (length props))))
	(if (null node)
	    (progn (setq noderef nil) (setq node nil))
	  (progn
	    (setq noderef (alist-get prop node))
	    (setq node (avl-node noderef))))))

    (if (or (null (last props)) (null node))
	nil
      (setcdr (assoc (car (last props)) node) value))))


(defun avl-height (noderef)
  (or (avl-node-prop noderef :height) -1))

(defun avl-reheight (noderef)
  (if (null noderef)
      nil
    (avl-set-prop noderef :height
                  (1+ (max (avl-height (avl-node-prop noderef :left))
		           (avl-height (avl-node-prop noderef :right)))))))

(defun avl-setbalance (noderef)
  ;;(when (integerp node) (setq node (avl-node node)))
  (avl-reheight noderef)
  (avl-set-prop noderef :balance
		(- (avl-height (avl-node-prop noderef :right))
		   (avl-height (avl-node-prop noderef :left)))))

(defun avl-add-node (key parent)
  (let (result (idx 0))
    (cl-loop for idx from 0 to (1- (seq-length avl-all-nodes))
             while (null result) do
             (when (null (aref avl-all-nodes idx))
	       (aset avl-all-nodes idx (avl-create-node key parent))
	       (setq result idx)))
    result))

(defun avl-insert (key)
  (if (null avl-root-node)
      (progn (setq avl-root-node (avl-add-node key nil)) avl-root-node)
    (progn
      (let ((n avl-root-node) (end-loop nil) parent go-left result)
	(while (not end-loop)
	  (if (equal key (avl-node-prop n :key))
	      (setq end-loop 't)
	    (progn
	      (setq parent n)
	      (setq go-left (> (avl-node-prop n :key) key))
	      (setq n (if go-left
                          (avl-node-prop n :left)
                        (avl-node-prop n :right)))
	
	      (when (null n)
                (setq result (avl-add-node key parent))
		(if go-left
		    (progn
		      (avl-set-prop parent :left result))
		  (progn
		    (avl-set-prop parent :right result)))
		(avl-rebalance parent) ;;rebalance
		(setq end-loop 't)))))
	result))))


(defun avl-rotate-left (noderef)
  (when (not (integerp noderef)) (error "parameter must be an integer"))
  (let ((a noderef) b)
    (setq b (avl-node-prop a :right))
    (avl-set-prop b :parent (avl-node-prop a :parent))

    (avl-set-prop a :right (avl-node-prop b :left))

    (when (avl-node-prop a :right) (avl-set-prop a :right :parent a))

    (avl-set-prop b :left a)
    (avl-set-prop a :parent b)

    (when (not (null (avl-node-prop b :parent)))
      (if (equal (avl-node-prop b :parent :right) a)
          (avl-set-prop b :parent :right b)
        (avl-set-prop b :parent :left b)))

    (avl-setbalance a)
    (avl-setbalance b)
    b))



(defun avl-rotate-right (node-idx)
  (when (not (integerp node-idx)) (error "parameter must be an integer"))
  (let ((a node-idx) b)
    (setq b (avl-node-prop a :left))
    (avl-set-prop b :parent (avl-node-prop a :parent))

    (avl-set-prop a :left (avl-node-prop b :right))

    (when (avl-node-prop a :right) (avl-set-prop a :right :parent a))

    (avl-set-prop b :left a)
    (avl-set-prop a :parent b)

    (when (not (null (avl-node-prop b :parent)))
      (if (equal (avl-node-prop b :parent :right) a)
          (avl-set-prop b :parent :right b)
        (avl-set-prop b :parent :left b)))

    (avl-setbalance a)
    (avl-setbalance b)
    b))

(defun avl-rotate-left-then-right (noderef)
  (avl-set-prop noderef :left (avl-rotate-left (avl-node-prop noderef :left)))
  (avl-rotate-right noderef))

(defun avl-rotate-right-then-left (noderef)
  (avl-set-prop noderef :right (avl-rotate-left (avl-node-prop noderef :right)))
  (avl-rotate-left noderef))

(defun avl-rebalance (noderef)
  (avl-setbalance noderef)
  (cond
   ((equal -2 (avl-node-prop noderef :balance))
    (if (>= (avl-height (avl-node-prop noderef :left :left))
	    (avl-height (avl-node-prop noderef :left :right)))
	(setq noderef (avl-rotate-right noderef))
      (setq noderef (avl-rotate-left-then-right noderef)))
    )
   ((equal 2 (avl-node-prop noderef :balance))
    (if (>= (avl-height (avl-node-prop noderef :right :right))
	    (avl-height (avl-node-prop noderef :right :left)))
	(setq noderef (avl-rotate-left noderef))
      (setq noderef (avl-rotate-right-then-left noderef)))))

  (if (not (null (avl-node-prop noderef :parent)))
      (avl-rebalance (avl-node-prop noderef :parent))
    (setq avl-root-node noderef)))


(defun avl-delete (noderef)
  (when noderef
    (when (and (null (avl-node-prop noderef :left))
               (null (avl-node-prop noderef :right)))
      (if (null (avl-node-prop noderef :parent))
          (setq avl-root-node nil)
        (let ((parent (avl-node-prop noderef :parent)))
          (if (equal noderef (avl-node-prop parent :left))
              (avl-set-prop parent :left nil)
            (avl-set-prop parent :right nil))
          (avl-rebalance parent))))

    (if (not (null (avl-node-prop noderef :left)))
        (let ((child (avl-node-prop noderef :left)))
          (while (not (null (avl-node-prop child :right)))
            (setq child (avl-node-prop child :right)))
          (avl-set-prop noderef :key (avl-node-prop child :key))
          (avl-delete child))
      (let ((child (avl-node-prop noderef :right)))
        (while (not (null (avl-node-prop child :left)))
          (setq child (avl-node-prop child :left)))
        (avl-set-prop noderef :key (avl-node-prop child :key))
        (avl-delete child)))))

;; Main procedure
(let ((cnt 10) balances)
  (fillarray avl-all-nodes nil)
  (setq avl-root-node nil)

  (dotimes (val cnt)
    (avl-insert (1+ val)))

  (setq balances (seq-map (lambda (x) (or (avl-node-prop x :balance) 0))
			  (number-sequence 0 (1- cnt))))

  (message "Inserting values 1 to %d" cnt)
  (message "Printing balance: %s" (string-join (seq-map (lambda (x) (format "%S" x)) balances) " ")))
