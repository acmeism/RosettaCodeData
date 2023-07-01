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

(defn primes-treeFoldingx
  "Computes the unbounded sequence of primes using a Sieve of Eratosthenes algorithm modified from Bird."
  []
  (letfn [(mltpls [p] (let [p2 (* 2 p)]
                        (letfn [(nxtmltpl [c]
                                  (->CIS c (fn [] (nxtmltpl (+ c p2)))))]
                          (nxtmltpl (* p p))))),
          (allmtpls [^CIS ps] (->CIS (mltpls (.v ps)) (fn [] (allmtpls ((.cont ps)))))),
          (union [^CIS xs ^CIS ys] (let [xv (.v xs), yv (.v ys)]
                                     (if (< xv yv) (->CIS xv (fn [] (union ((.cont xs)) ys)))
                                       (if (< yv xv) (->CIS yv (fn [] (union xs ((.cont ys)))))
                                         (->CIS xv (fn [] (union (next xs) ((.cont ys))))))))),
          (pairs [^CIS mltplss] (let [^CIS tl ((.cont mltplss))]
                                  (->CIS (union (.v mltplss) (.v tl))
                                         (fn [] (pairs ((.cont tl))))))),
          (mrgmltpls [^CIS mltplss] (->CIS (.v ^CIS (.v mltplss))
                                           (fn [] (union ((.cont ^CIS (.v mltplss)))
                                                         (mrgmltpls (pairs ((.cont mltplss)))))))),
          (minusStrtAt [n ^CIS cmpsts] (loop [n n, cmpsts cmpsts]
                                         (if (< n (.v cmpsts))
                                           (->CIS n (fn [] (minusStrtAt (+ n 2) cmpsts)))
                                           (recur (+ n 2) ((.cont cmpsts))))))]
    (do (def oddprms (->CIS 3 (fn [] (let [cmpsts (-> oddprms (allmtpls) (mrgmltpls))]
                                       (minusStrtAt 5 cmpsts)))))
        (->CIS 2 (fn [] oddprms)))))
