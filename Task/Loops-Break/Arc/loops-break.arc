(point break
  (while t
    (let x (rand 20)
      (prn "a: " x)
      (if (is x 0)
        (break)))
    (prn "b: " (rand 20))))
