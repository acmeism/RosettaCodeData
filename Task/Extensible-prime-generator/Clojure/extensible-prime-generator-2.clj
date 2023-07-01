(deftype CIS [v cont]
  clojure.lang.ISeq
    (first [_] v)
    (next [_] (if (nil? cont) nil (cont)))
    (more [this] (let [nv (.next this)] (if (nil? nv) (CIS. nil nil) nv)))
    (cons [this o] (clojure.core/cons o this))
    (empty [_] (if (and (nil? v) (nil? cont)) nil (CIS. nil nil)))
    (equiv [this o] (loop [cis1 this, cis2 o] (if (nil? cis1) (if (nil? cis2) true false)
                                                (if (or (not= (type cis1) (type cis2))
                                                        (not= (.v cis1) (.v ^CIS cis2))
                                                        (and (nil? (.cont cis1))
                                                              (not (nil? (.cont ^CIS cis2))))
                                                        (and (nil? (.cont ^CIS cis2))
                                                              (not (nil? (.cont cis1))))) false
                                                  (if (nil? (.cont cis1)) true
                                                    (recur ((.cont cis1)) ((.cont ^CIS cis2))))))))
    (count [this] (loop [cis this, cnt 0] (if (or (nil? cis) (nil? (.cont cis))) cnt
                                            (recur ((.cont cis)) (inc cnt)))))
  clojure.lang.Seqable
    (seq [this] (if (and (nil? v) (nil? cont)) nil this))
  clojure.lang.Sequential
  Object
    (toString [this] (if (and (nil? v) (nil? cont)) "()" (.toString (seq (map identity this))))))

(comment " the wheel could also be a pre-determined vector as for the 2/3/5/7 wheel below...
(def wheel
  [ 2 4 2 4 6 2 6 4 2 4 6 6 2 6  4  2
    6 4 6 8 4 2 4 2 4 8 6 4 6 2  4  6
    2 6 6 4 2 4 6 2 6 4 2 4 2 10 2 10 ])
")

(def wheel-primes [2 3 5 7 11 13 17])

(def next-prime 19)

(def nextnext-prime 23)

;; calculates the vector for very large wheels such as the 92160 element version here
;; the disadvantage is that it takes some time to calculate before the work can start...
(def wheel
  (loop [p 2, len 1, ^bytes ptrn [1]]
    (if (>= p next-prime)
      ptrn
      (let [cptrn (cycle ptrn), [f & rcyc] cptrn,
            np (+ p f), nlen (* len (- p 1)),
            culls
              (map (fn [[f _]] f)
                (iterate (fn [[c [g & r]]] [(+ c (* p g)) r]) [(* p p) cptrn])),
            gaps (drop 1
                    (for [[gp _ _ _ cnt]
                            (iterate (fn [[_ v cls [g & rgs] c]]
                                  (let [[cl & rcls] cls, tv (+ v g),
                                        [sg & srgs] rgs, nc (+ c 1)]
                                    (if (= cl tv)
                                      [(+ g sg) (+ tv sg) rcls srgs nc]
                                      [g tv cls rgs nc])))
                                [f np culls rcyc 0]) :while (<= cnt nlen)] gp))]
        (recur np nlen (vec gaps))))))

(def wheellmt (- (count wheel) 1))

(defn primes-treeFolding
  "Computes the unbounded sequence of primes using a Sieve of Eratosthenes algorithm modified from Bird."
  []
  (letfn [(mltpls [[p pi]]
            (letfn [(nxtmltpl [c ci]
                      (let [nci (if (< ci wheellmt) (+ ci 1) 0)]
                        (->CIS c #(-> (nxtmltpl (+ c (* p (get wheel ci))) nci)))))]
              (nxtmltpl (* p p) pi))),
          (allmtpls [^CIS pxs]
            (->CIS (mltpls (.v pxs)) #(-> (allmtpls ((.cont pxs)))))),
          (union [^CIS xs ^CIS ys]
            (let [xv (.v xs), yv (.v ys)]
              (if (< xv yv) (->CIS xv #(-> (union ((.cont xs)) ys)))
                (if (< yv xv)
                  (->CIS yv #(-> (union xs ((.cont ys)))))
                  (->CIS xv #(-> (union (next xs) ((.cont ys))))))))),
          (pairs [^CIS mltplss] (let [^CIS tl ((.cont mltplss))]
                                  (->CIS (union (.v mltplss) (.v tl))
                                          #(-> (pairs ((.cont tl))))))),
          (mrgmltpls [^CIS mltplss]
            (->CIS (.v ^CIS (.v mltplss))
                    #(-> (union ((.cont ^CIS (.v mltplss)))
                                (mrgmltpls (pairs ((.cont mltplss)))))))),
          (minusStrtAt [n ni ^CIS cmpsts]
            (let [nn (+ n (get wheel ni)), nni (if (< ni wheellmt) (+ ni 1) 0)]
              (if (< n (.v cmpsts))
                (->CIS [n ni] #(-> (minusStrtAt nn nni cmpsts)))
                (recur nn nni ((.cont cmpsts)))))),
          (xtraprmsndxd []
            (->CIS [next-prime 0] #(-> (minusStrtAt nextnext-prime 1
                                (mrgmltpls (allmtpls (xtraprmsndxd))))))),
          (stripndxs [^CIS ndxd]
            (->CIS (get (.v ndxd) 0) #(-> (stripndxs ((.cont ndxd))))))]
    (loop [i (- (count wheel-primes) 1), ff (fn [] (stripndxs (xtraprmsndxd)))]
        (if (<= i 0)
          (->CIS (get wheel-primes 0) ff)
          (recur (- i 1) (fn [] (->CIS (get wheel-primes i) ff)))))))
