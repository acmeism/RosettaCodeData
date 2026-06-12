;; * Using external libraries with quicklisp
(eval-when (:load-toplevel :compile-toplevel :execute)
  (ql:quickload '("pileup" "iterate")))

;; * The package definition
(defpackage :a*-search
  (:use :common-lisp :pileup :iterate))
(in-package :a*-search)

;; * The data
(defvar *size* 8
  "The size of the area.")

;; I will use simple conses for the positions and directions.
(defvar *barriers*
  '((2 . 4) (2 . 5) (2 . 6) (3 . 6) (4 . 6) (5 . 6) (5 . 5) (5 . 4) (5 . 3) (5 . 2)
    (4 . 2) (3 . 2))
  "The position of the barriers in (X Y) pairs, starting with (0 0) at the lower
  left corner.")

(defvar *barrier-cost* 100 "The costs of a barrier field.")

(defvar *directions* '((0 . -1) (0 . 1) (1 . 0) (-1 . 0) (-1 . -1) (1 . 1))
  "The possible directions left, right, up, down and diagonally.")

;; * Tha data structure for the node in the search graph
(defstruct (node (:constructor node))
  (pos (cons 0 0) :type cons)
  (path nil)
  (cost 0 :type fixnum)                 ; The costs so far
  (f-value 0 :type fixnum)              ; The value for the heuristics
  )

;; * The functions

;; ** Printing the final path
(defun print-path (path start end &optional (barriers *barriers*)
                   &aux (size (+ 2 *size*)))
  "Prints the area with the BARRIERS."
  ;; The upper boarder
  (format t "~v@{~A~:*~}~%" size "█")
  ;; The actual area
  ;; The lines
  (iter (for y from (1- *size*) downto 0)
        (format t "█")
        ;; The columns
        (iter (for x from 0 below *size*)
              (format t "~A"
                      (cond ((member (cons y x) barriers :test #'equal) "█")
                            ((equal (cons y x) start) "●")
                            ((equal (cons y x) end) "◆")
                            ((Member (cons y x) path :test #'equal) "▪")
                            (t " "))))
        ;; The last column and jump to the next line
        (format t "█~%"))
  ;; The lower boarder
  (format t "~v@{~A~:*~}~%" size "█")
  (iter
    (for position in path)
    (format t "(~D,~D)" (car position) (cdr position))
    (finally (terpri))))

;; ** Generating the next positions
;; *** Check if a position is possible
(defun valid-position-p (position)
  "Returns T if POSITION is a valid position."
  (let ((x (car position))
        (y (cdr position))
        (max (1- *size*)))
    (and (<= 0 x max)
         (<= 0 y max))))

;; *** Move from the current position in direction
(defun move (position direction)
  "Returns a new position after moving from POSITION in DIRECTION assuming only
valid positions."
  (let ((x (car position))
        (y (cdr position))
        (dx (car direction))
        (dy (cdr direction)))
    (cons (+ x dx) (+ y dy))))

;; *** Generate the possible next positions
(defun next-positions (current-position)
  "Returns a list of conses with possible next positions."
  (remove-if-not #'valid-position-p
                 (mapcar (lambda (d) (move current-position d)) *directions*)))

;; ** The heuristics
(defun distance (current-position goal)
  "Returns the Manhattan distance from CURRENT-POSITION to GOAL."
  (+ (abs (- (car goal) (car current-position)))
     (abs (- (cdr goal) (cdr current-position)))))

;; ** The A+ search
(defun a* (start goal heuristics next &optional (information 0))
  "Returns the shortest path from START to GOAL using HEURISTICS, generating the
  next nodes using NEXT."
  (let ((visited (make-hash-table :test #'equalp)))
    (flet ((pick-next-node (queue)
             ;; Get the next node from the queue
             (heap-pop queue))
           (expand-node (node queue)
             ;; Expand the next possible nodes from node and add them to the
             ;; queue if not already visited.
             (iter
               (with costs = (node-cost node))
               (for position in (funcall next (node-pos node)))
               (for cost = (1+ costs))
               (for f-value = (+ cost (funcall heuristics position goal)
                                 (if (member position *barriers* :test #'equal)
                                     100
                                     0)))
               ;; Check if this state was already looked at
               (unless (gethash position visited)
               ;; Insert the next node into the queue
               (heap-insert
                (node :pos position :path (cons position (node-path node))
                      :cost cost :f-value f-value)
                queue)))))

      ;; The actual A* search
      (iter
        ;; The priority queue
        (with queue = (make-heap #'<= :name "queue" :size 1000 :key #'node-f-value))
        (with initial-cost = (funcall heuristics start goal))
        (initially (heap-insert (node :pos start :path (list start) :cost 0
                                      :f-value initial-cost)
                                queue))
        (for counter from 1)
        (for current-node = (pick-next-node queue))
        (for current-position = (node-pos current-node))
        ;; Output some information each counter or nothing if information
        ;; equals 0.
        (when (and (not (zerop information))
                   (zerop (mod counter information)))
          (format t "~Dth Node, heap size: ~D, current costs: ~D~%"
                  counter (heap-count queue)
                  (node-cost current-node)))

        ;; If the target is not reached continue
        (until (equalp current-position goal))
        ;; Add the current state to the hash of visited states
        (setf (gethash current-node visited) t)
        ;; Expand the current node and continue
        (expand-node current-node queue)
        (finally (return (values (nreverse (node-path current-node))
                                 (node-cost current-node)
                                 counter)))))))

;; ** The main function
(defun search-path (&key (start '(0 . 0)) (goal '(7 . 7)) (heuristics #'distance))
  "Searches the shortest path from START to GOAL using HEURISTICS."
  (multiple-value-bind (path cost steps)
      (a* start goal heuristics #'next-positions 0)
    (format t "Found the shortest path from Start (●) to Goal (◆) in ~D steps with cost: ~D~%" steps cost)
    (print-path path start goal)))
