(cond
  (= 1 2) :no) ; returns nil

(cond
  (= 1 2) :no
  (= 1 1) :yes) ; returns :yes
