(deftype Stack [elements])

(def stack (Stack (ref ())))

(defn push-stack
  "Pushes an item to the top of the stack."
  [x] (dosync (alter (:elements stack) conj x)))

(defn pop-stack
  "Pops an item from the top of the stack."
  [] (let [fst (first (deref (:elements stack)))]
       (dosync (alter (:elements stack) rest)) fst))

(defn top-stack
  "Shows what's on the top of the stack."
  [] (first (deref (:elements stack))))

(defn empty-stack?
  "Tests whether or not the stack is empty."
  [] (= () (deref (:elements stack))))
