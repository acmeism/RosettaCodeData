(point break
  (while t
    (let x (rand 20)
      (prn "a: " x)
      (if (is x 10)
        (break)))
    (prn "b: " (rand 20))))
