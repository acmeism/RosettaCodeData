(defun main ()
  (let ((dims 0) (target nil) (hits 0))

    ;;; distance node to target:
    ;;; returns squared euclidean distance, or squared semi distance if option set
    (defun distance (n &optional (semi nil))
      (if semi (expt (- (nth (first n) (second n)) (nth (first n) target)) 2)
          (reduce #'+ (mapcar (lambda (x y) (* (- x y) (- x y))) (second n) target))))

    ;;; returns true if target is to its left in axis dim
    (defun target< (n)
      (< (nth (first n) target) (nth (first n) (second n))))

    ;;; return the next child when nn searching, return opposing child if option oppose set
    (defun next-node (n &optional (oppose nil))
      (if (or (and (target< n) (not oppose)) (and (not (target< n)) oppose)) (third n) (fourth n)))

    ;;; a kdtree is a binary tree where nodes are:
    ;;; terminal: (axis data-point),  or
    ;;; branch:   (axis split-point (left-kdtree) (right-kdtree))
    (defun make-kdtree(axis data)
      (if (null data) nil
          (if (eql (length data) 1) ; singleton?
              (list axis (first data)) ;; terminal node
              ;; else branch node:
              ;; #pts=odd  splits list into 2 even parts with sp in middle
              ;; #pts=even splits list into 2 uneven parts with shorter length first (but never nil)
              (let ((sd (sort (copy-list data) #'< :key (lambda (x) (nth axis x)))) ;; sort the axis ordinates
                    (sp (truncate (/ (length data) 2))) ;; get mid pt
                    (nxta (mod (1+ axis) dims)))
                (list axis (nth sp sd) (make-kdtree nxta (subseq sd 0 sp)) (make-kdtree nxta (subseq sd (1+ sp))))))))

    ;;; depth first visit all nodes in kdtree and optionally apply a function to each node visited
    (defun visit-kdtree (kdt &key (node-function null))
      (when kdt
        (when node-function (funcall node-function kdt))
        (visit-kdtree (third kdt) :node-function node-function)
        (visit-kdtree (fourth kdt) :node-function node-function)))

    ;;; count of the terminal nodes
    (defun count-nodes (kdt)
      (if kdt
          (if (eql (length kdt) 2) 1
              (+ 1 (count-nodes (third kdt)) (count-nodes (fourth kdt))))
          0))

    ;;; nearest neighbour search
    (defun nn-kdtree (kdt node-stack)
      (when kdt
        ;; stage 1 - find the 'closest' terminal node using insertion logic
        (let ((best (do ((node kdt (next-node node))) ((not (next-node node)) (incf hits) node) ;; return first best est.
                      (push node node-stack) (incf hits)))) ; iteration

          ;; stage 2 - unwind the path, at each node if node is closer then make it best
          (do ((node (pop node-stack) (pop node-stack))) ((null node) best) ;; return nearest pt
            ;; iteration: update best if node is closer
            (when (< (distance node) (distance best))
              (setf best node))

            ;; venture down opposing side if split point is inside HS
            (let ((opposing-best
                   (if (< (distance node 'semi) (distance best)) ; use semi dist here
                       (nn-kdtree (next-node node 'opposite) (list))
                       nil))) ;; otherwise ignore this subtree

              (when (and opposing-best (< (distance opposing-best) (distance best)))
                (setf best opposing-best)))))))

    ;;; process one set of data & optionally display tree
    (defun process (data tgt &optional (render nil))
      (setf target tgt)
      (setf dims (length target))
      (setf hits 0)
      (let* ((kdt (make-kdtree 0 data)) (nn (nn-kdtree kdt (list))))
        (when render
          (visit-kdtree kdt
                        :node-function (lambda (n)
                                         (format t "~A node: axis:~A point: ~A target:~A semi-distance-sqd:~A euclidean-distance-sqd:~A~%"
                                                 (if (not (next-node n)) "TERMINAL" "BRANCH") (first n) (second n)
                                                 target (distance n 'semi) (distance n)))))
        (format t "~%NN to ~A is ~A, distance ~A [tree has ~A nodes, ~A were visited.]~%" target (second nn) (sqrt (distance nn)) (count-nodes kdt) hits)))

    ;; MAIN: TASK 1 - nn search small set of 2D points
    (process '((2 3) (5 4) (9 6) (4 7) (8 1) (7 2)) '(9 2) 'render)

    ;; TASK 2 - nn search 1000 coordinate points in 3D space
    (process
     (progn (let ((ll (list))) (dotimes (i 10) (dotimes (j 10) (dotimes (k 10) (push (list i j k) ll)))) ll))
     (list (float (/ (random 1000) 100)) (float (/ (random 1000) 100)) (float (/ (random 1000) 100))))))
