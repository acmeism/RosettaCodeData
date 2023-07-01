;;; Using a priority queue for the A* search
(eval-when (:load-toplevel :compile-toplevel :execute)
  (ql:quickload "pileup"))

;; * The package definition
(defpackage :15-solver
  (:use :common-lisp :pileup)
  (:export "15-puzzle-solver" "*initial-state*" "*goal-state*"))
(in-package :15-solver)

;; * Data types
(defstruct (posn (:constructor posn))
  "A posn is a pair struct containing two integer for the row/col indices."
  (row 0 :type fixnum)
  (col 0 :type fixnum))

(defstruct (state (:constructor state))
  "A state contains a vector and a posn describing the position of the empty slot."
  (matrix '#(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 0) :type simple-vector)
  (empty-slot (posn :row 3 :col 3) :type posn))

(defparameter directions '(up down left right)
  "The possible directions shifting the empty slot.")

(defstruct (node (:constructor node))
  "A node contains a state, a reference to the previous node, a g value (actual
costs until this node, and a f value (g value + heuristics)."
  (state (state) :type state)
  (prev nil)
  (cost 0 :type fixnum)
  (f-value 0 :type fixnum))

;; * Some constants
(defparameter *side-size* 4 "The size of the puzzle.")

(defvar *initial-state*
  (state :matrix #(15  14  1  6
                    9  11  4 12
                    0  10  7  3
                   13   8  5  2)
         :empty-slot (posn :row 2 :col 0)))

(defvar *initial-state-2*
  (state :matrix #( 0 12  9 13
                   15 11 10 14
                    3  7  2  5
                    4  8  6  1)
         :empty-slot (posn :row 0 :col 0)))

(defvar *goal-state*
  (state :matrix #( 1  2  3  4
                    5  6  7  8
                    9 10 11 12
                   13 14 15  0)
          :empty-slot (posn :row 3 :col 3)))

;; * The functions

;; ** Accessing the elements of the puzzle
(defun matrix-ref (matrix row col)
  "Matrices are simple vectors, abstracted by following functions."
  (svref matrix (+ (* row *side-size*) col)))

(defun (setf matrix-ref) (val matrix row col)
  (setf (svref matrix (+ (* row *side-size*) col)) val))

;; ** The final predicate
(defun target-state-p (state goal-state)
  "Returns T if STATE is the goal state."
  (equalp state goal-state))

(defun valid-movement-p (direction empty-slot)
  "Returns T if direction is allowed for the current empty slot position."
  (case direction
    (up (< (posn-row empty-slot) (1- *side-size*)))
    (down (> (posn-row empty-slot) 0))
    (left (< (posn-col empty-slot) (1- *side-size*)))
    (right (> (posn-col empty-slot) 0))))

;; ** Pretty print the state
(defun print-state (state)
  "Helper function to pretty-print a state."
  (format t " ====================~%")
  (loop
     with matrix = (state-matrix state)
     for i from 0 below *side-size*
     do
       (loop
          for j from 0 below *side-size*
          do (format t "| ~2,D " (matrix-ref matrix i j)))
       (format t " |~%"))
  (format t " ====================~%"))

;; ** Move the empty slot
(defun move (state direction)
  "Returns a new state after moving STATE's empty-slot in DIRECTION assuming a
  valid direction."
  (let* ((matrix (copy-seq (state-matrix state)))
         (empty-slot (state-empty-slot state))
         (r (posn-row empty-slot))
         (c (posn-col empty-slot))
         (new-empty-slot
          (ccase direction
            (up (setf (matrix-ref matrix r c) (matrix-ref matrix (1+ r) c)
                      (matrix-ref matrix (1+ r) c) 0)
                (posn :row (1+ r) :col c))
            (down (setf (matrix-ref matrix r c) (matrix-ref matrix (1- r) c)
                        (matrix-ref matrix (1- r) c) 0)
                  (posn :row (1- r) :col c))
            (left (setf (matrix-ref matrix r c) (matrix-ref matrix r (1+ c))
                        (matrix-ref matrix r (1+ c)) 0)
                  (posn :row r :col (1+ c)))
            (right (setf (matrix-ref matrix r c) (matrix-ref matrix r (1- c))
                         (matrix-ref matrix r (1- c)) 0)
                   (posn :row r :col (1- c))))))
    (state :matrix matrix :empty-slot new-empty-slot)))

;; ** The heuristics
(defun l1-distance (posn0 posn1)
  "Returns the L1 distance between two positions."
  (+ (abs (- (posn-row posn0) (posn-row posn1)))
     (abs (- (posn-col posn0) (posn-col posn1)))))

(defun element-cost (val current-posn)
  "Returns the L1 distance between the current position and the goal-position
for VAL."
  (if (zerop val)
      (l1-distance current-posn (posn :row 3 :col 3))
      (multiple-value-bind (target-row target-col)
          (floor (1- val) *side-size*)
        (l1-distance current-posn (posn :row target-row :col target-col)))))

(defun distance-to-goal (state)
  "Returns the L1 distance from STATE to the goal state."
  (loop
     with matrix = (state-matrix state)
     with sum = 0
     for i below *side-size*
     do (loop
           for j below *side-size*
           for val = (matrix-ref matrix i j)
           for cost = (element-cost val (posn :row i :col j))
           unless (zerop val)
           do (incf sum cost))
     finally (return sum)))

(defun out-of-order-values (list)
  "Returns the number of values out of order."
  (flet ((count-values (list)
           (loop
              with a = (first list)
              with rest = (rest list)
              for b in rest
              when (> b a)
              count b)))
    (loop
       for candidates = list then (rest candidates)
       while candidates
       summing (count-values candidates) into result
       finally (return (* 2 result)))))

(defun row-conflicts (row state0 state1)
  "Returns the number of conflicts in the given row, i.e. value in the right row
  but in the wrong order. For each conflicted pair add 2 to the value, but a
  maximum of 6 to avoid over-estimation."
  (let* ((goal-row (loop
                      with matrix1 = (state-matrix state1)
                      for j below *side-size*
                      collect (matrix-ref matrix1 row j)))
         (in-goal-row (loop
                         with matrix0 = (state-matrix state0)
                         for j below *side-size*
                         for val = (matrix-ref matrix0 row j)
                         when (member val goal-row)
                         collect val)))
    (min 6 (out-of-order-values
            ;; 0 does not lead to a linear conflict
            (remove 0 (nreverse in-goal-row))))))

(defun col-conflicts (col state0 state1)
  "Returns the number of conflicts in the given column, i.e. value in the right
  row but in the wrong order. For each conflicted pair add 2 to the value, but a
  maximum of 6 to avoid over-estimation."
  (let* ((goal-col (loop
                      with matrix1 = (state-matrix state1)
                      for i below *side-size*
                      collect (matrix-ref matrix1 i col)))
         (in-goal-col (loop
                         with matrix0 = (state-matrix state0)
                         for i below *side-size*
                         for val = (matrix-ref matrix0 i col)
                         when (member val goal-col)
                         collect val)))
    (min 6 (out-of-order-values
            ;; 0 does not lead to a linear conflict
            (remove 0 (nreverse in-goal-col))))))

(defun linear-conflicts (state0 state1)
  "Returns the linear conflicts for state1 with respect to state0."
  (loop
     for i below *side-size*
     for row-conflicts = (row-conflicts i state0 state1)
     for col-conflicts = (col-conflicts i state0 state1)
     summing row-conflicts into all-row-conflicts
     summing col-conflicts into all-col-conflicts
     finally (return (+ all-row-conflicts all-col-conflicts))))

(defun state-heuristics (state)
  "Using the L1 distance and the number of linear conflicts as heuristics."
  (+ (distance-to-goal state)
     (linear-conflicts state *goal-state*)))

;; ** Generate the next possible states.
(defun next-state-dir-pairs (current-node)
  "Returns a list of pairs containing the next states and the direction for the
  movement of the empty slot."
  (let* ((state (node-state current-node))
         (empty-slot (state-empty-slot state))
         (valid-movements (remove-if-not (lambda (dir) (valid-movement-p dir empty-slot))
                                         directions)))
    (map 'list (lambda (dir) (cons (move state dir) dir)) valid-movements)))

;; ** Searching the shortest paths and reconstructing the movements
(defun reconstruct-movements (leaf-node)
  "Traverse all nodes until the initial state and return a list of symbols
describing the path."
  (labels ((posn-diff (p0 p1)
             ;; Compute a pair describing the last move
             (posn :row (- (posn-row p1) (posn-row p0))
                        :col (- (posn-col p1) (posn-col p0))))
           (find-movement (prev-state state)
             ;; Describe the last movement of the empty slot with R, L, U or D.
             (let* ((prev-empty-slot (state-empty-slot prev-state))
                    (this-empty-slot (state-empty-slot state))
                    (delta (posn-diff prev-empty-slot this-empty-slot)))
               (cond ((equalp delta (posn :row  1 :col  0)) 'u)
                     ((equalp delta (posn :row -1 :col  0)) 'd)
                     ((equalp delta (posn :row  0 :col  1)) 'l)
                     ((equalp delta (posn :row  0 :col -1)) 'r))))
           (iter (node path)
             (if (or (not node) (not (node-prev node)))
                 path
                 (iter (node-prev node)
                       (cons (find-movement (node-state node)
                                            (node-state (node-prev node)))
                             path)))))
    (iter leaf-node '())))

(defun A* (initial-state
           &key (goal-state *goal-state*) (heuristics #'state-heuristics)
             (information 0))
  "An A* search for the shortest path to *GOAL-STATE*"
  (let ((visited (make-hash-table :test #'equalp))) ; All states visited so far
    ;; Some internal helper functions
    (flet ((pick-next-node (queue)
             ;; Get the next node from the queue
             (heap-pop queue))
           (expand-node (node queue)
             ;; Expand the next possible nodes from node and add them to the
             ;; queue if not already visited.
             (loop
                with costs = (node-cost node)
                with successors = (next-state-dir-pairs node)
                for (state . dir) in successors
                for succ-cost = (1+ costs)
                for f-value = (+ succ-cost (funcall heuristics state))
                ;; Check if this state was already looked at
                unless (gethash state visited)
                do
                ;; Insert the next node into the queue
                  (heap-insert
                   (node :state state :prev node :cost succ-cost
                              :f-value f-value)
                   queue))))

      ;; The actual A* search
      (loop
         ;; The priority queue
         with queue = (make-heap #'<= :name "queue" :size 1000 :key #'node-f-value)
         with initial-state-cost = (funcall heuristics initial-state)
         initially (heap-insert (node :state initial-state :prev nil :cost 0
                                           :f-value initial-state-cost)
                                queue)
         for counter from 1
         for current-node = (pick-next-node queue)
         for current-state = (node-state current-node)
         ;; Output some information each counter or nothing if information
         ;; equals 0.
         when (and (not (zerop information))
                   (zerop (mod counter information)))
         do (format t "~Dth State, heap size: ~D, current costs: ~D~%"
                    counter (heap-count queue)
                    (node-cost current-node))

         ;; If the target is not reached continue
         until (target-state-p current-state goal-state)
         do
         ;; Add the current state to the hash of visited states
           (setf (gethash current-state visited) t)
         ;; Expand the current node and continue
           (expand-node current-node queue)
         finally (return (values (reconstruct-movements current-node) counter))))))

;; ** Pretty print the path
(defun print-path (path)
  "Prints the directions of PATH and its length."
  (format t "~{~A~} ~D moves~%" path (length path)))

;; ** Get some timing information
(defmacro timing (&body forms)
  "Return both how much real time was spend in body and its result"
  (let ((start (gensym))
	(end (gensym))
	(result (gensym)))
    `(let* ((,start (get-internal-real-time))
	    (,result (progn ,@forms))
	    (,end (get-internal-real-time)))
       (values ,result (/ (- ,end ,start) internal-time-units-per-second)))))

;; ** The main function
(defun 15-puzzle-solver (initial-state &key (goal-state *goal-state*))
  "Solves a given and valid 15 puzzle and returns the shortest path to reach the
  goal state."
  (print-state initial-state)
  (multiple-value-bind (result time)
      (timing (multiple-value-bind (path steps)
                      (a* initial-state :goal-state goal-state)
                (print-path path)
                steps))
   (format t "Found the shortest path in ~D steps and ~3,2F seconds~%" result time))
  (print-state goal-state))
