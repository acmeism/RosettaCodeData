;; Calculating the number e, euler-napier number.
;; We will use two methods
;; First method: the forumula (1 + 1/n)^n
;; Second method: the series partial sum 1/(p!)


;;first method

(defn inverse-plus-1 [n]
  (+ 1 (/ 1 n)))

(defn e-return [n]
  (Math/pow (inverse-plus-1 n) n))

(time (e-return 100000.))

;;"Elapsed time: 0.165629 msecs"
;;2.7182682371922975

;;SECOND METHOD

(defn method-e [n]
  (loop [e-aprx 0M
        value-add 1M
        p  1M]
    (if (> p n)
    e-aprx
    (recur (+ e-aprx value-add) (/ value-add p) (inc p)))))

(time (with-precision 110 (method-e 200M)))
