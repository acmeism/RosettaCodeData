(let ((data #(1 2 3 4 5)))     ; the array
  (values (reduce #'+ data)       ; sum
          (reduce #'* data)))     ; product
