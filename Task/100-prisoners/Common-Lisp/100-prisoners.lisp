(defparameter *samples* 10000)
(defparameter *prisoners* 100)
(defparameter *max-guesses* 50)

(defun range (n)
  "Returns a list from 0 to N."
  (loop
     for i below n
     collect i))

(defun nshuffle (list)
  "Returns a shuffled LIST."
  (loop
     for i from (length list) downto 2
     do (rotatef (nth (random i) list)
                 (nth (1- i) list)))
  list)

(defun build-drawers ()
  "Returns a list of shuffled drawers."
  (nshuffle (range *prisoners*)))

(defun strategy-1 (drawers p)
  "Returns T if P is found in DRAWERS under *MAX-GUESSES* using a random strategy."
  (loop
     for i below *max-guesses*
     thereis (= p (nth (random *prisoners*) drawers))))

(defun strategy-2 (drawers p)
  "Returns T if P is found in DRAWERS under *MAX-GUESSES* using an optimal strategy."
  (loop
     for i below *max-guesses*
     for j = p then (nth j drawers)
     thereis (= p (nth j drawers))))

(defun 100-prisoners-problem (strategy &aux (drawers (build-drawers)))
  "Returns T if all prisoners find their number using the given STRATEGY."
  (every (lambda (e) (eql T e))
         (mapcar (lambda (p) (funcall strategy drawers p)) (range *prisoners*))))

(defun sampling (strategy)
  (loop
     repeat *samples*
     for result = (100-prisoners-problem strategy)
     count result))

(defun compare-strategies ()
  (format t "Using a random strategy in ~4,2F % of the cases the prisoners are free.~%" (* (/ (sampling #'strategy-1) *samples*) 100))
  (format t "Using an optimal strategy in ~4,2F % of the cases the prisoners are free.~%" (* (/ (sampling #'strategy-2) *samples*) 100)))
