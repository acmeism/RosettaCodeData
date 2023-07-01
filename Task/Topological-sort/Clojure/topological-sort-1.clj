(use 'clojure.set)
(use 'clojure.contrib.seq-utils)

(defn dep
  "Constructs a single-key dependence, represented as a map from
   item to a set of items, ensuring that item is not in the set."
  [item items]
  {item (difference (set items) (list item))})

(defn empty-dep
  "Constructs a single-key dependence from item to an empty set."
  [item]
  (dep item '()))

(defn pair-dep
  "Invokes dep after destructuring item and items from the argument."
  [[item items]]
  (dep item items))

(defn default-deps
  "Constructs a default dependence map taking every item
   in the argument to an empty set"
  [items]
  (apply merge-with union (map empty-dep (flatten items))))

(defn declared-deps
  "Constructs a dependence map from a list containaining
   alternating items and list of their predecessor items."
  [items]
  (apply merge-with union (map pair-dep (partition 2 items))))

(defn deps
  "Constructs a full dependence map containing both explicitly
   represented dependences and default empty dependences for
   items without explicit predecessors."
  [items]
  (merge (default-deps items) (declared-deps items)))

(defn no-dep-items
  "Returns all keys from the argument which have no (i.e. empty) dependences."
  [deps]
  (filter #(empty? (deps %)) (keys deps)))

(defn remove-items
  "Returns a dependence map with the specified items removed from keys
   and from all dependence sets of remaining keys."
  [deps items]
  (let [items-to-remove (set items)
        remaining-keys  (difference (set (keys deps)) items-to-remove)
        remaining-deps  (fn [x] (dep x (difference (deps x) items-to-remove)))]
    (apply merge (map remaining-deps remaining-keys))))

(defn topo-sort-deps
  "Given a dependence map, returns either a list of items in which each item
   follows all of its predecessors, or a string showing the items among which
   there is a cyclic dependence preventing a linear order."
  [deps]
  (loop [remaining-deps deps
         result         '()]
    (if (empty? remaining-deps)
        (reverse result)
        (let [ready-items (no-dep-items remaining-deps)]
          (if (empty? ready-items)
              (str "ERROR: cycles remain among " (keys remaining-deps))
              (recur (remove-items remaining-deps ready-items)
                     (concat ready-items result)))))))

(defn topo-sort
  "Given a list of alternating items and predecessor lists, constructs a
   full dependence map and then applies topo-sort-deps to that map."
  [items]
  (topo-sort-deps (deps items)))
