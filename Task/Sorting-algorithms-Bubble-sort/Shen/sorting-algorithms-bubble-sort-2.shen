(datatype some-globals

  __________
  (value *arr*) : (vector number);)

(set *arr* (vector 5))
(vector-> (value *arr*) 1 5)
(vector-> (value *arr*) 2 1)
(vector-> (value *arr*) 3 4)
(vector-> (value *arr*) 4 2)
(vector-> (value *arr*) 5 8)
(bubble-sort (value *arr*))
