(set! *unchecked-math* true)

(def PGSZ (bit-shift-left 1 14)) ;; size of CPU cache
(def PGBTS (bit-shift-left PGSZ 3))
(def PGWRDS (bit-shift-right PGBTS 5))
(def BPWRDS (bit-shift-left 1 7)) ;; smaller page buffer for base primes
(def BPBTS (bit-shift-left BPWRDS 5))
(defn- count-pg
  "count primes in the culled page buffer, with test for limit"
  [lmt ^ints pg]
  (let [pgsz (alength pg),
        pgbts (bit-shift-left pgsz 5),
        cntem (fn [lmtw]
                (let [lmtw (long lmtw)]
	          (loop [i (long 0), c (long 0)]
	            (if (>= i lmtw) (- (bit-shift-left lmtw 5) c)
	              (recur (inc i)
	              (+ c (java.lang.Integer/bitCount (aget pg i))))))))]
    (if (< lmt pgbts)
      (let [lmtw (bit-shift-right lmt 5),
            lmtb (bit-and lmt 31)
            msk (bit-shift-left -2 lmtb)]
        (+ (cntem lmtw)
           (- 32 (java.lang.Integer/bitCount (bit-or (aget pg lmtw)
                                                      msk)))))
      (- pgbts
         (areduce pg i ret (long 0) (+ ret (java.lang.Integer/bitCount (aget pg i))))))))
;;      (cntem pgsz))))
(defn- primes-pages
  "unbounded Sieve of Eratosthenes producing a lazy sequence of culled page buffers."
  []
  (letfn [(make-pg [lowi pgsz bpgs]
            (let [lowi (long lowi),
                  pgbts (long (bit-shift-left pgsz 5)),
                  pgrng (long (+ (bit-shift-left (+ lowi pgbts) 1) 3)),
                  ^ints pg (int-array pgsz),
                  cull (fn [bpgs']
                         (loop [i (long 0), bpgs' bpgs']
	                         (let [^ints fbpg (first bpgs'),
	                               bpgsz (long (alength fbpg))]
	                           (if (>= i bpgsz)
	                             (recur 0 (next bpgs'))
	                             (let [p (long (aget fbpg i)),
	                                   sqr (long (* p p))]
	                               (if (< sqr pgrng) (do
                   (loop [j (long (let [s (long (bit-shift-right (- sqr 3) 1))]
                                     (if (>= s lowi) (- s lowi)
                                       (let [m (long (rem (- lowi s) p))]
                                         (if (zero? m)
                                           0
                                           (- p m))))))]
                     (if (< j pgbts) ;; fast inner culling loop where most time is spent
                       (do
                         (let [w (bit-shift-right j 5)]
                           (aset pg w (int (bit-or (aget pg w)
                                                   (bit-shift-left 1 (bit-and j 31))))))
                         (recur (+ j p)))))
                     (recur (inc i) bpgs'))))))))]
              (do (if (nil? bpgs)
                    (letfn [(mkbpps [i]
                              (if (zero? (bit-and (aget pg (bit-shift-right i 5))
                                                  (bit-shift-left 1 (bit-and i 31))))
                                (cons (int-array 1 (+ i i 3)) (lazy-seq (mkbpps (inc i))))
                                (recur (inc i))))]
                      (cull (mkbpps 0)))
                    (cull bpgs))
                  pg))),
          (page-seq [lowi pgsz bps]
            (letfn [(next-seq [lwi]
                      (cons (make-pg lwi pgsz bps)
                            (lazy-seq (next-seq (+ lwi (bit-shift-left pgsz 5))))))]
              (next-seq lowi)))
          (pgs->bppgs [ppgs]
            (letfn [(nxt-pg [lowi pgs]
                      (let [^ints pg (first pgs),
                            cnt (count-pg BPBTS pg),
                            npg (int-array cnt)]
                        (do (loop [i 0, j 0]
                              (if (< i BPBTS)
                                (if (zero? (bit-and (aget pg (bit-shift-right i 5))
                                                    (bit-shift-left 1 (bit-and i 31))))
                                  (do (aset npg j (+ (bit-shift-left (+ lowi i) 1) 3))
                                      (recur (inc i) (inc j)))
                                  (recur (inc i) j))))
                            (cons npg (lazy-seq (nxt-pg (+ lowi BPBTS) (next pgs)))))))]
              (nxt-pg 0 ppgs))),
          (make-base-prms-pgs []
            (pgs->bppgs (cons (make-pg 0 BPWRDS nil)
                              (lazy-seq (page-seq BPBTS BPWRDS (make-base-prms-pgs))))))]
    (page-seq 0 PGWRDS (make-base-prms-pgs))))
(defn primes-paged
  "unbounded Sieve of Eratosthenes producing a lazy sequence of primes"
  []
  (do (deftype CIS [v cont]
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
		  (letfn [(next-prm [lowi i pgseq]
		            (let [lowi (long lowi),
                      i (long i),
                      ^ints pg (first pgseq),
		                  pgsz (long (alength pg)),
		                  pgbts (long (bit-shift-left pgsz 5)),
		                  ni (long (loop [j (long i)]
		                             (if (or (>= j pgbts)
		                                     (zero? (bit-and (aget pg (bit-shift-right j 5))
		                                               (bit-shift-left 1 (bit-and j 31)))))
		                               j
		                               (recur (inc j)))))]
		              (if (>= ni pgbts)
		                (recur (+ lowi pgbts) 0 (next pgseq))
		                (->CIS (+ (bit-shift-left (+ lowi ni) 1) 3)
		                       (fn [] (next-prm lowi (inc ni) pgseq))))))]
		    (->CIS 2 (fn [] (next-prm 0 0 (primes-pages)))))))
(defn primes-paged-count-to
  "counts primes generated by page segments by Sieve of Eratosthenes to the top limit"
  [top]
  (cond (< top 2) 0
        (< top 3) 1
        :else (letfn [(nxt-pg [lowi pgseq cnt]
                        (let [topi (bit-shift-right (- top 3) 1)
                              nxti (+ lowi PGBTS),
                              pg (first pgseq)]
                          (if (> nxti topi)
                            (+ cnt (count-pg (- topi lowi) pg))
                            (recur nxti
                                   (next pgseq)
                                   (+ cnt (count-pg PGBTS pg))))))]
                (nxt-pg 0 (primes-pages) 1))))
