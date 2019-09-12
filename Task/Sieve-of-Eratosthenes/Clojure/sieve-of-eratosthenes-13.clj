(deftype PQEntry [k, v]
  Object
    (toString [_] (str "<" k "," v ">")))
(deftype PQNode [ntry, lft, rght]
  Object
    (toString [_] (str "<" ntry " left: " (str lft) " right: " (str rght) ">")))

(defn empty-pq [] nil)

(defn getMin-pq [^PQNode pq]
  (if (nil? pq)
    nil
    (.ntry pq)))

(defn insert-pq [^PQNode opq ok v]
  (loop [^PQEntry kv (->PQEntry ok v), pq opq, cont identity]
    (if (nil? pq)
      (cont (->PQNode kv nil nil))
      (let [k (.k kv),
            ^PQEntry kvn (.ntry pq), kn (.k kvn),
            l (.lft pq), r (.rght pq)]
        (if (<= k kn)
          (recur kvn r #(cont (->PQNode kv % l)))
          (recur kv r #(cont (->PQNode kvn % l))))))))

(defn replaceMinAs-pq [^PQNode opq k v]
  (let [^PQEntry kv (->PQEntry k v)]
    (if (nil? opq) ;; if was empty or just an entry, just use current entry
      (->PQNode kv nil nil)
      (loop [pq opq, cont identity]
        (let [^PQNode l (.lft pq), ^PQNode r (.rght pq)]
          (cond ;; if left us empty, right must be too
            (nil? l)
              (cont (->PQNode kv nil nil)),
            (nil? r) ;; we only have a left...
              (let [^PQEntry kvl (.ntry l), kl (.k kvl)]
                    (if (<= k kl)
                      (cont (->PQNode kv l nil))
                      (recur l #(cont (->PQNode kvl % nil))))),
            :else (let [^PQEntry kvl (.ntry l), kl (.k kvl),
                        ^PQEntry kvr (.ntry r), kr (.k kvr)] ;; we have both
                    (if (and (<= k kl) (<= k kr))
                      (cont (->PQNode kv l r))
                      (if (<= kl kr)
                        (recur l #(cont (->PQNode kvl % r)))
                        (recur r #(cont (->PQNode kvr l %))))))))))))
