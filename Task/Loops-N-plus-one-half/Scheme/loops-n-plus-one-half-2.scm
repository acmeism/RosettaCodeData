(let loop ((i 0))
  (display i)
  (if (= i 10)
      (newline)
      (begin
        (display ", ")
        (loop (+ 1 i)))))
