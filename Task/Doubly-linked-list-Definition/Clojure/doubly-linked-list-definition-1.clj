(ns double-list)

(defprotocol PDoubleList
  (get-head [this])
  (add-head [this x])
  (get-tail [this])
  (add-tail [this x])
  (remove-node [this node])
  (add-before [this node x])
  (add-after [this node x])
  (get-nth [this n]))

(defrecord Node [prev next data])

(defn make-node
  "Create an internal or finalized node"
  ([prev next data] (Node. prev next data))
  ([m key] (when-let [node (get m key)]
            (assoc node :m m :key key))))

(defn get-next [node] (make-node (:m node) (:next node)))
(defn get-prev [node] (make-node (:m node) (:prev node)))

(defn- seq* [m start next]
  (seq
   (for [x (iterate #(get m (next %)) (get m start))
         :while x]
     (:data x))))

(defmacro when->
  ([x pred form] `(let [x# ~x] (if ~pred (-> x# ~form) x#)))
  ([x pred form & more] `(when-> (when-> ~x ~pred ~form) ~@more)))

(declare get-nth-key)

(deftype DoubleList [m head tail]
  Object
    (equals [this x]
      (and (instance? DoubleList x)
           (= m (.m ^DoubleList x))))
    (hashCode [this] (hash (or this ())))
  clojure.lang.Sequential
  clojure.lang.Counted
    (count [_] (count m))
  clojure.lang.Seqable
    (seq [_] (seq* m head :next))
  clojure.lang.Reversible
    (rseq [_] (seq* m tail :prev))
  clojure.lang.IPersistentCollection
    (empty [_] (DoubleList. (empty m) nil nil))
    (equiv [this x]
      (and (sequential? x)
           (= (seq x) (seq this))))
    (cons [this x] (.add-tail this x))
  PDoubleList
    (get-head [_] (make-node m head))
    (add-head [this x]
      (let [new-key (Object.)
            m (when-> (assoc m new-key (make-node nil head x))
                head (assoc-in [head :prev] new-key))
            tail (if tail tail new-key)]
        (DoubleList. m new-key tail)))
    (get-tail [_] (make-node m tail))
    (add-tail [this x]
      (if-let [tail (.get-tail this)]
        (.add-after this tail x)
        (.add-head this x)))
    (remove-node [this node]
      (if (get m (:key node))
        (let [{:keys [prev next key]} node
              head (if prev head next)
              tail (if next tail prev)
              m (when-> (dissoc m key)
                  prev (assoc-in [prev :next] next)
                  next (assoc-in [next :prev] prev))]
          (DoubleList. m head tail))
        this))
    (add-after [this node x]
      (if (get m (:key node))
        (let [{:keys [prev next key]} node
              new-key (Object.)
              m (when-> (-> (assoc m new-key  (make-node key next x))
                            (assoc-in , [key :next] new-key))
                  next (assoc-in [next :prev] new-key))
              tail (if next tail new-key)]
          (DoubleList. m head tail))
        this))
    (add-before [this node x]
      (if (:prev node)
        (.add-after this (get-prev node) x)
        (.add-head this x)))
    (get-nth [this n] (make-node m (get-nth-key this n))))

(defn get-nth-key [^DoubleList this n]
  (if (< -1 n (.count this))
    (let [[start next n] (if (< n (/ (.count this) 2))
                           [(.head this) :next n]
                           [(.tail this) :prev (- (.count this) n 1)])]
      (nth (iterate #(get-in (.m this) [% next]) start) n))
    (throw (IndexOutOfBoundsException.))))

(defn double-list
  ([] (DoubleList. nil nil nil))
  ([coll] (into (double-list) coll)))

(defmethod print-method DoubleList [dl w]
  (print-method (interpose '<-> (seq dl)) w))

(defmethod print-method Node [n w]
  (print-method (symbol "#:double_list.Node") w)
  (print-method (into {} (dissoc n :m)) w))
