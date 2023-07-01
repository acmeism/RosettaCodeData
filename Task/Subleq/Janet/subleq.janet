(defn main [& args]
  (let [filename  (get args 1)
        fh        (file/open filename)
        program   (file/read fh :all)
        memory    (eval-string (string "@[" program "]"))
        size      (length memory)]

    (var pc 0)

    (while (<= 0 pc size)
      (let [a (get memory pc)
            b (get memory (inc pc))
            c (get memory (+ pc 2))]
      (set pc (+ pc 3))
      (cond
        (< a 0) (put memory b (first (file/read stdin 1)))
        (< b 0) (file/write stdout (buffer/push-byte @"" (get memory a)))
        true
          (do
            (put memory b (- (get memory b) (get memory a)))
            (if (<= (get memory b) 0)
               (set pc c))))))))
