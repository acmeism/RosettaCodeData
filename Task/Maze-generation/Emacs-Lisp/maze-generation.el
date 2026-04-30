(require 'cl-lib)

(cl-defstruct maze rows cols data)

(defmacro maze-pt (w r c)
  `(+ (* (mod ,r (maze-rows ,w)) (maze-cols ,w))
      (mod ,c (maze-cols ,w))))

(defmacro maze-ref (w r c)
  `(aref (maze-data ,w) (maze-pt ,w ,r ,c)))

(defun new-maze (rows cols)
  (setq rows (1+ rows)
        cols (1+ cols))
  (let ((m (make-maze :rows rows :cols cols :data (make-vector (* rows cols) nil))))

    (dotimes (r rows)
      (dotimes (c cols)
        (setf (maze-ref m r c) (copy-sequence '(wall ceiling)))))

    (dotimes (r rows)
      (maze-set m r (1- cols) 'visited))

    (dotimes (c cols)
      (maze-set m (1- rows) c 'visited))

    (maze-unset m 0 0 'ceiling) ;; Maze Entrance
    (maze-unset m (1- rows) (- cols 2) 'ceiling) ;; Maze Exit

    m))

(defun maze-is-set (maze r c v)
  (member v (maze-ref maze r c)))

(defun maze-set (maze r c v)
  (let ((cell (maze-ref maze r c)))
    (when (not (member v cell))
      (setf (maze-ref maze r c) (cons v cell)))))

(defun maze-unset (maze r c v)
  (setf (maze-ref maze r c) (delete v (maze-ref maze r c))))

(defun print-maze (maze &optional marks)
  (dotimes (r (1- (maze-rows maze)))

    (dotimes (c (1- (maze-cols maze)))
      (princ (if (maze-is-set maze r c 'ceiling) "+---" "+   ")))
    (princ "+")
    (terpri)

    (dotimes (c (1- (maze-cols maze)))
      (princ (if (maze-is-set maze r c 'wall) "|" " "))
      (princ (if (member (cons r c) marks) " * " "   ")))
    (princ "|")
    (terpri))

  (dotimes (c (1- (maze-cols maze)))
    (princ (if (maze-is-set maze (1- (maze-rows maze)) c 'ceiling) "+---" "+   ")))
  (princ "+")
  (terpri))

(defun shuffle (lst)
  (sort lst (lambda (a b) (= 1 (random 2)))))

(defun to-visit (maze row col)
  (let (unvisited)
    (dolist (p '((0 . +1) (0 . -1) (+1 . 0) (-1 . 0)))
      (let ((r (+ row (car p)))
            (c (+ col (cdr p))))
      (unless (maze-is-set maze r c 'visited)
        (push (cons r c) unvisited))))
    unvisited))

(defun make-passage (maze r1 c1 r2 c2)
  (if (= r1 r2)
      (if (< c1 c2)
          (maze-unset maze r2 c2 'wall) ; right
        (maze-unset maze r1 c1 'wall))  ; left
    (if (< r1 r2)
        (maze-unset maze r2 c2 'ceiling)   ; up
      (maze-unset maze r1 c1 'ceiling))))  ; down

(defun dig-maze (maze row col)
  (let (backup
        (run 0))
    (maze-set maze row col 'visited)
    (push (cons row col) backup)
    (while backup
      (setq run (1+ run))
      (when (> run (/ (+ row col) 3))
        (setq run 0)
        (setq backup (shuffle backup)))
      (setq row (caar backup)
            col (cdar backup))
      (let ((p (shuffle (to-visit maze row col))))
        (if p
            (let ((r (caar p))
                  (c (cdar p)))
              (make-passage maze row col r c)
              (maze-set maze r c 'visited)
              (push (cons r c) backup))
          (pop backup)
          (setq backup (shuffle backup))
          (setq run 0))))))

(defun generate (rows cols)
  (let* ((m (new-maze rows cols)))
    (dig-maze m (random rows) (random cols))
    (print-maze m)))

(defun parse-ceilings (line)
  (let (rtn
        (i 1))
    (while (< i (length line))
      (push (eq ?- (elt line i)) rtn)
      (setq i (+ i 4)))
    (nreverse rtn)))

(defun parse-walls (line)
  (let (rtn
        (i 0))
    (while (< i (length line))
      (push (eq ?| (elt line i)) rtn)
      (setq i (+ i 4)))
    (nreverse rtn)))

(defun parse-maze (file-name)
  (let ((rtn)
        (lines (with-temp-buffer
                 (insert-file-contents-literally file-name)
                 (split-string (buffer-string) "\n" t))))
    (while lines
      (push (parse-ceilings (pop lines)) rtn)
      (push (parse-walls (pop lines)) rtn))
    (nreverse rtn)))

(defun read-maze (file-name)
  (let* ((raw (parse-maze file-name))
         (rows (1- (/ (length raw) 2)))
         (cols (length (car raw)))
         (maze (new-maze rows cols)))
    (dotimes (r rows)
      (let ((ceilings (pop raw)))
        (dotimes (c cols)
          (unless (pop ceilings)
            (maze-unset maze r c 'ceiling))))
      (let ((walls (pop raw)))
        (dotimes (c cols)
          (unless (pop walls)
            (maze-unset maze r c 'wall)))))
    maze))

(defun find-exits (maze row col)
  (let (exits)
    (dolist (p '((0 . +1) (0 . -1) (-1 . 0) (+1 . 0)))
      (let ((r (+ row (car p)))
            (c (+ col (cdr p))))
        (unless
            (cond
             ((equal p '(0 . +1)) (maze-is-set maze r   c   'wall))
             ((equal p '(0 . -1)) (maze-is-set maze row col 'wall))
             ((equal p '(+1 . 0)) (maze-is-set maze r   c   'ceiling))
             ((equal p '(-1 . 0)) (maze-is-set maze row col 'ceiling)))
          (push (cons r c) exits))))
    exits))

(defun drop-visited (maze points)
  (let (not-visited)
    (while points
      (unless (maze-is-set maze (caar points) (cdar points) 'visited)
        (push (car points) not-visited))
      (pop points))
    not-visited))

(defun solve-maze (maze)
  (let (solution
        (exit (cons (- (maze-rows maze) 2) (- (maze-cols maze) 2)))
        (pt (cons 0 0)))
    (while (not (equal pt exit))
      (maze-set maze (car pt) (cdr pt) 'visited)
      (let ((exits (drop-visited maze (find-exits maze (car pt) (cdr pt)))))
        (if (null exits)
            (setq pt (pop solution))
          (push pt solution)
          (setq pt (pop exits)))))
    (push pt solution)))

(defun solve (file-name)
  (let* ((maze (read-maze file-name))
         (solution (solve-maze maze)))
    (print-maze maze solution)))

(generate 20 20)
