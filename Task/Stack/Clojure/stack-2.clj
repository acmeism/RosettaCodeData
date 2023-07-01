(defprotocol StackOps
  (push-stack [this x] "Pushes an item to the top of the stack.")
  (pop-stack [this] "Pops an item from the top of the stack.")
  (top-stack [this] "Shows what's on the top of the stack.")
  (empty-stack? [this] "Tests whether or not the stack is empty."))
(deftype Stack [elements]
  StackOps
   (push-stack [x] (dosync (alter elements conj x)))
   (pop-stack [] (let [fst (first (deref elements))]
		   (dosync (alter elements rest)) fst))
   (top-stack [] (first (deref elements)))
   (empty-stack? [] (= () (deref elements))))

(def stack (Stack (ref ())))
