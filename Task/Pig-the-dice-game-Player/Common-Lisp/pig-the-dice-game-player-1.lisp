(defclass player ()
    ((score :initform 0 :accessor score)
     (name :initarg :name :accessor name)))
(defun make-player (name)
  (make-instance 'player :name name))
(defmethod has-won ((player player))
  (>= (score player) 100))

(defclass score-based (player)
  ((score-base :initarg :score-base :initform 25 :accessor score-base)))
(defun make-score-based (name &optional (base 25))
  (make-instance 'score-based :score-base base :name name))
(defmethod roll-again ((player score-based) other turn-score)
  (declare (ignorable other))
  (< turn-score (score-base player)))

(defclass neller (player) ())
(defun make-neller (name) (make-instance 'neller :name name))
(defmethod roll-again ((player neller) other turn-score)
  (let ((other-score (score other)) (my-score (score player)))
     (or
      (> other-score 71)
      (> my-score 71)
      (< turn-score (+ 21 (/ (- other-score my-score) 8))))))

(defun query-turn (player other roll added-score)
  (format t "~A: Rolled a ~A - Turn: ~A Current Score: ~A Keep rolling (Y, N or Q)?"
    (name player)
    roll
    added-score
    (+ added-score (score player)))
  (let ((ret (roll-again player other added-score)))
    (if ret (format t "Y~%") (format t "N~%"))
    ret))

(defun do-turns (player other)
  (do ((new-score 0)
       (take-turn t))
      ((not take-turn) (setf (score player) (+ (score player) new-score)))
    (let ((roll (+ 1 (random 6))))
      (cond
       ((>= (+ (score player) roll new-score) 100)
        (format t "~A rolls a ~A and WINS!~%" (name player) roll)
        (setf new-score (+ new-score roll))
        (setf take-turn nil))
       ((eql 1 roll)
        (format t "Ooh!  Sorry - ~A rolled a 1 and busted!~%" (name player))
        (setf new-score 0)
        (setf take-turn nil))
       (t
        (setf new-score (+ new-score roll))
        (setf take-turn (query-turn player other roll new-score)))))))

(defun play-pig-winner (p1 p2)
    (do* ((otherplayer p2 curplayer)
          (curplayer p1 (if (eql curplayer p1) p2 p1)))
         ((has-won otherplayer) otherplayer)
      (do-turns curplayer otherplayer)))

(defun play-pig-player (player1 player2)
  (catch 'quit (format t "Hooray! ~A won the game!"
