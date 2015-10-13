(deftype PQEntry [k, v]
  Object
    (toString [_] (str "<" k "," v ">")))
(deftype PQNode [^PQEntry ntry, lft, rght, lvl]
  Object
    (toString [_] (str "<" lvl ntry " left: " (str lft) " right: " (str rght) ">")))

(defn empty-pq [] nil)

(defn getMin-pq ^PQEntry [pq] (condp instance? pq
                                PQEntry pq,
                                PQNode (.ntry ^PQNode pq)
                                nil))

(defn insert-pq [opq k v]
  (loop [kv (->PQEntry k v), msk 0, pq opq, cont identity]
    (condp instance? pq
      PQEntry (if (< k (.k ^PQEntry pq)) (cont (->PQNode kv pq nil 2))
                                         (cont (->PQNode pq kv nil 2))),
      PQNode (let [^PQNode pqn pq, kvn (.ntry pqn), l (.lft pqn), r (.rght pqn),
                   nlvl (+ (.lvl pqn) 1),
                   nmsk (if (zero? msk) ;; never ever 0 again with the bit or'ed 1
                          (bit-or (bit-shift-left nlvl (- 64 (long (quot (Math/log (double nlvl))
                                                                         (Math/log (double 2)))))) 1)
                          (bit-shift-left msk 1))]
               (if (<= k (.k ^PQEntry kvn))
                 (if (neg? nmsk)
                   (recur kvn nmsk r (fn [npq] (cont (->PQNode kv l npq nlvl))))
                   (recur kvn nmsk l (fn [npq] (cont (->PQNode kv npq r nlvl)))))
                 (if (neg? nmsk)
                   (recur kv nmsk r (fn [npq] (cont (->PQNode kvn l npq nlvl))))
                   (recur kv nmsk l (fn [npq] (cont (->PQNode kvn npq r nlvl))))))),
      (cont kv))))

(defn replaceMinAs-pq [opq k v]
  (let [kv (->PQEntry k v)]
    (loop [pq opq, cont identity]
      (if (instance? PQNode pq)
        (let [^PQNode pqn pq, l (.lft pqn), r (.rght pqn), lvl (.lvl pqn)]
          (cond
            (and (instance? PQEntry r) (> k (.k ^PQEntry r)))
              (cond ;; right not empty so left is never empty
                (and (instance? PQEntry l) (> k (.k ^PQEntry l))) ;; both qualify; choose least
                  (if (> (.k ^PQEntry l) (.k ^PQEntry r))
                    (cont (->PQNode r l kv lvl))
                    (cont (->PQNode l kv r lvl))),
                (and (instance? PQNode l) (> k (.k ^PQEntry (.ntry ^PQNode l))))
                  (let [^PQEntry kvl (.ntry ^PQNode l)]
                    (if (> (.k kvl) (.k ^PQEntry r)) ;; both qualify; choose least
                      (cont (->PQNode r l kv lvl))
                      (recur l (fn [npq] (cont (->PQNode kvl npq r lvl)))))),
                :else (cont (->PQNode r l kv lvl))), ;; only right qualifies; no recursion
            (and (instance? PQNode r) (> k (.k ^PQEntry (.ntry ^PQNode r))))
              (let [^PQEntry kvr (.ntry ^PQNode r)]
                (if (and (instance? PQNode l) (> k (.k ^PQEntry (.ntry ^PQNode l))))
                  (let [^PQEntry kvl (.ntry ^PQNode l)]
                    (if (> (.k kvl) (.k kvr)) ;; both qualify; choose least
                      (recur r (fn [npq] (cont (->PQNode kvr l npq lvl))))
                      (recur l (fn [npq] (cont (->PQNode kvl npq r lvl))))))
                  (recur r (fn [npq] (cont (->PQNode kvr l npq lvl)))))), ;; only right qualifies
            :else (cond ;; right is empty, but as this is a node, left is never empty
                    (and (instance? PQEntry l) (> k (.k ^PQEntry l)))
                      (cont (->PQNode l kv r lvl)),
                    (and (instance? PQNode l) (> k (.k ^PQEntry (.ntry ^PQNode l))))
                      (recur l (fn [npq] (cont (->PQNode (.ntry ^PQNode l) npq r lvl)))),
                    :else (cont (->PQNode kv l r lvl))))) ;; just replace contents, leave same
        (cont kv))))) ;; if was empty or just an entry, just use current entry
