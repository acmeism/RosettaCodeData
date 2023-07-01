(defn swap [l a b]
  (let [aval (get l a) bval (get l b)]
    (put l a bval)
    (put l b aval)))

(defn heap-sort [l]
  (def len (length l))
  # Invariant: heap[parent] <= heap[*children]
  (def heap (array/new (+ len 1)))
  (array/push heap nil)
  (def ROOT 1)

  # Returns the parent index of index, or nil if none
  (defn parent [idx]
    (assert (> idx 0))
    (if (= idx 1) nil (math/trunc (/ idx 2))))
  # Returns a tuple [a b] of the two child indices of idx
  (defn children [idx]
    (def a (* idx 2))
    (def b (+ a 1))
    (def l (length heap))
    # NOTE: `if` implicitly returns nil on false
    [(if (< a l) a) (if (< b l) b)])
  (defn check-invariants [idx]
    (def [a b] (children idx))
    (def p (parent idx))
    (assert (or (nil? a) (<= (get heap idx) (get heap a))))
    (assert (or (nil? b) (<= (get heap idx) (get heap b))))
    (assert (or (nil? p) (>= (get heap idx) (get heap p)))))
  (defn swim [idx]
    (def val (get heap idx))
    (def parent-idx (parent idx))
    (when (and (not (nil? parent-idx)) (< val (get heap parent-idx)))
      (swap heap parent-idx idx)
      (swim parent-idx)
    )
    (check-invariants idx))


  (defn sink [idx]
    (def [a b] (children idx))
    (def target-val (get heap idx))
    (def smaller-children @[])
    (defn handle-child [idx]
      (let [child-val (get heap idx)]
        (if (and (not (nil? idx)) (< child-val target-val))
          (array/push smaller-children idx))))
    (handle-child a)
    (handle-child b)
    (assert (<= (length smaller-children) 2))
    (def smallest-child (cond
      (empty? smaller-children) nil
      (= 1 (length smaller-children)) (get smaller-children 0)
      (< (get heap (get smaller-children 0)) (get heap (get smaller-children 1))) (get smaller-children 0)
      # NOTE: The `else` for final branch of `cond` is implicit
      (get smaller-children 1)
    ))
    (unless (nil? smallest-child)
      (swap heap smallest-child idx)
      (sink smallest-child)
      # Recheck invariants
      (check-invariants idx)))

  (defn insert [val]
    (def idx (length heap))
    (array/push heap val)
    (swim idx))

  (defn remove-smallest []
    (assert (> (length heap) 1))
    (def largest (get heap ROOT))
    (def new-root (array/pop heap))
    (when (> (length heap) 1)
      (put heap ROOT new-root)
      (sink ROOT))
    (assert (not (nil? largest)))
    largest)

  (each item l (insert item))

  (def res @[])
  (while (> (length heap) 1)
    (array/push res (remove-smallest)))
  res)

# NOTE: Makes a copy of input array. Output is mutable
(print (heap-sort [7 12 3 9 -1 17 6]))
