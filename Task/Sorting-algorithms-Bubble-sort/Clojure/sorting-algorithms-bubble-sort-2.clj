(defn- bubble-step
  "was-changed: whether any elements prior to the current first element
  were swapped;
  returns a two-element vector [partially-sorted-sequence is-sorted]"
 [less? xs was-changed]
  (if (< (count xs) 2)
    [xs (not was-changed)]
    (let [[x1 x2 & xr] xs
	  first-is-smaller   (less? x1 x2)
	  is-changed         (or was-changed (not first-is-smaller))
	  [smaller larger]   (if first-is-smaller [x1 x2] [x2 x1])
	  [result is-sorted] (bubble-step
			      less? (cons larger xr) is-changed)]
      [(cons smaller result) is-sorted])))

(defn bubble-sort
  "Takes an optional less-than predicate and a sequence.
  Returns the sorted sequence.
  Very inefficient (O(n²))"
  ([xs] (bubble-sort <= xs))
  ([less? xs]
     (let [[result is-sorted] (bubble-step less? xs false)]
       (if is-sorted
	 result
	 (recur less? result)))))

(println (bubble-sort [10 9 8 7 6 5 4 3 2 1]))
