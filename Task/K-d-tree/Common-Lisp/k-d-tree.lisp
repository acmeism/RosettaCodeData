(in-package cl-user)

(defvar *random-target*
  (list (float (/ (random 1000) 100))
        (float (/ (random 1000) 100))
        (float (/ (random 1000) 100))))

(defun distance (n target &key (semi nil))
  "distance node to target:
returns squared euclidean distance, or squared semi distance if option set"
  (if semi
      (expt (- (nth (first n) (second n))
               (nth (first n) target))
            2)
      (reduce #'+
              (mapcar (lambda (x y) (* (- x y) (- x y)))
                      (second n)
                      target))))

(defun target< (n target)
  "returns true if target is to its left in axis dim"
  (< (nth (first n) target)
     (nth (first n) (second n))))

(defun next-node (n target &key (opposite nil))
  "return the next child when nn searching, return opposing child if option
oppose set"
  (if (or (and (target< n target) (not opposite))
          (and (not (target< n target)) opposite))
      (third n)
      (fourth n)))

(defun make-kdtree (axis data dims)
  "a kdtree is a binary tree where nodes are:
terminal: (axis data-point),  or
branch:   (axis split-point (left-kdtree) (right-kdtree))"
  (cond ((null data) nil)
        ((eql (length data) 1)          ; singleton?
         (list axis (first data)))      ; terminal node
        ;; else branch node:
        ;; #pts=odd  splits list into 2 even parts with sp in middle
        ;; #pts=even splits list into 2 uneven parts with shorter length first (but never nil)
        (t
         (let ((sd (sort (copy-list data)
                         #'<
                         :key (lambda (x) (nth axis x)))) ; sort the axis ordinates
               (sp (truncate (length data) 2)) ; get mid pt
               (nxta (mod (1+ axis) dims)))
           (list axis
                 (nth sp sd)
                 (make-kdtree nxta
                              (subseq sd 0 sp)
                              dims)
                 (make-kdtree nxta
                              (subseq sd (1+ sp))
                              dims))))))

(defun visit-kdtree (kdt &key (node-function nil))
  "depth first visit all nodes in kdtree and optionally apply a function to
each node visited"
  (when kdt
    (when node-function (funcall node-function kdt))
    (visit-kdtree (third kdt) :node-function node-function)
    (visit-kdtree (fourth kdt) :node-function node-function)))

(defun count-nodes (kdt)
  "count of the terminal nodes"
  (cond ((null kdt) 0)
        ((= (length kdt) 2) 1)
        (t (+ 1
              (count-nodes (third kdt))
              (count-nodes (fourth kdt))))))

(defvar *hits*)

(defun nn-kdtree (kdt node-stack target)
  "nearest neighbour search"
  (when kdt
    ;; stage 1 - find the 'closest' terminal node using insertion logic
    (let ((best (do ((node kdt (next-node node target)))
                    ((not (next-node node target))
                     (incf *hits*)
                     node)              ; return first best est.
                  (push node node-stack)
                  (incf *hits*))))
      ;; stage 2 - unwind the path, at each node if node is closer then make it best
      (do ((node (pop node-stack) (pop node-stack)))
          ((null node) best)         ; return nearest pt
        ;; iteration: update best if node is closer
        (when (< (distance node target) (distance best target))
          (setf best node))
        ;; venture down opposing side if split point is inside HS
        (let ((opposing-best
                (if (< (distance node target :semi t) (distance best target))
                    (nn-kdtree (next-node node target :opposite t)
                               (list)
                               target)
                    nil)))              ; otherwise ignore this subtree
          (when (and opposing-best
                     (< (distance opposing-best target) (distance best target)))
            (setf best opposing-best)))))))

(defun process (data target
                &key (render nil)
                &aux (dims (length target)))
  "process one set of data & optionally display tree"
  (let* ((*hits* 0)
         (kdt (make-kdtree 0 data dims))
         (nn (nn-kdtree kdt (list) target)))
    (when render
      (visit-kdtree kdt
                    :node-function
                    (lambda (n)
                      (format t
                              "~A node: axis:~A point: ~A target:~A semi-distance-sqd:~A euclidean-distance-sqd:~A~%"
                              (if (not (next-node n target))
                                  "TERMINAL"
                                  "BRANCH")
                              (first n)
                              (second n)
                              target
                              (distance n target :semi t)
                              (distance n target)))))
    (format t "~%NN to ~A is ~A, distance ~A [tree has ~A nodes, ~A were visited.]~%"
            target
            (second nn)
            (sqrt (distance nn target))
            (count-nodes kdt)
            *hits*)))

(defun main ()
  ;; TASK 1 - nn search small set of 2D points
  (process '((2 3) (5 4) (9 6) (4 7) (8 1) (7 2))
           '(9 2)
           :render t)

  ;; TASK 2 - nn search 1000 coordinate points in 3D space
  (process (let ((ll (list)))
             (dotimes (i 10)
               (dotimes (j 10)
                 (dotimes (k 10)
                   (push (list i j k) ll))))
             ll)
           *random-target*))
