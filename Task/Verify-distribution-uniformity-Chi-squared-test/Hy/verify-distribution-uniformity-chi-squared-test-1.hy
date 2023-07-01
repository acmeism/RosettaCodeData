(import
  [scipy.stats [chisquare]]
  [collections [Counter]])

(defn uniform? [f repeats &optional [alpha .05]]
  "Call 'f' 'repeats' times and do a chi-squared test for uniformity
  of the resulting discrete distribution. Return false iff the
  null hypothesis of uniformity is rejected for the test with
  size 'alpha'."
  (<= alpha (second (chisquare
    (.values (Counter (take repeats (repeatedly f))))))))
