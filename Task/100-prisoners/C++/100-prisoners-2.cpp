(ns clips-sandbox.prisoners)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 100 Prisoners Problem — CLIPS Implementation
;; Implements the classical "loop strategy" and estimates success
;; probability by simulation.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconstant NUM-PRISONERS 100)
(defconstant NUM-BOXES 100)
(defconstant MAX-OPENS 50)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utility: shuffle a list (Fisher–Yates)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction shuffle (?lst)
  (bind ?n (length$ ?lst))
  (while (> ?n 1) do
    (bind ?k (+ 1 (random ?n)))
    (bind ?tmp (nth$ ?n ?lst))
    (bind ?lst (replace$ ?lst ?n ?n (nth$ ?k ?lst)))
    (bind ?lst (replace$ ?lst ?k ?k ?tmp))
    (bind ?n (- ?n 1)))
  ?lst)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Create a random permutation of 1..100 representing box contents
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction random-permutation ()
  (shuffle (create$ 1 2 3 4 5 6 7 8 9 10
                    11 12 13 14 15 16 17 18 19 20
                    21 22 23 24 25 26 27 28 29 30
                    31 32 33 34 35 36 37 38 39 40
                    41 42 43 44 45 46 47 48 49 50
                    51 52 53 54 55 56 57 58 59 60
                    61 62 63 64 65 66 67 68 69 70
                    71 72 73 74 75 76 77 78 79 80
                    81 82 83 84 85 86 87 88 89 90
                    91 92 93 94 95 96 97 98 99 100)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Prisoner loop strategy:
;; Start at your own number, open that box, then follow the chain.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction prisoner-succeeds (?id ?perm)
  (bind ?next ?id)
  (bind ?opens 0)
  (while (< ?opens MAX-OPENS) do
    (bind ?opens (+ ?opens 1))
    (bind ?found (nth$ ?next ?perm))
    (if (= ?found ?id) then
      (return TRUE))
    (bind ?next ?found))
  FALSE)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Run one full trial: all prisoners must succeed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction run-trial ()
  (bind ?perm (random-permutation))
  (foreach ?p (create$ 1 to NUM-PRISONERS) do
    (if (not (prisoner-succeeds ?p ?perm)) then
      (return FALSE)))
  TRUE)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Run many trials to estimate probability
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffunction simulate (?trials)
  (bind ?wins 0)
  (loop-for-count (?i 1 ?trials) do
    (if (run-trial) then
      (bind ?wins (+ ?wins 1))))
  (printout t "Trials: " ?trials crlf)
  (printout t "Successful trials: " ?wins crlf)
  (printout t "Estimated probability: "
               (/ (float ?wins) (float ?trials)) crlf))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Entry point
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(reset)
(simulate 1000)
