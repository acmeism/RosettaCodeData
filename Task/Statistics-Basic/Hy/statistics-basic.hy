(import
  [numpy.random [random]]
  [numpy [mean std]]
  [matplotlib.pyplot :as plt])

(for [n [100 1000 10000]]
  (setv v (random n))
  (print "Mean:" (mean v) "SD:" (std v)))

(plt.hist (random 1000))
(plt.show)
