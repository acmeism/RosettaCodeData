(define (foo  , mxcnt cnt times)
  (let (handle (open "mlijobs.txt" "read"))
    (while (search handle { (IN|OUT) +@ +(\S+)} true 0)
      (case $1
        ("OUT"
          (when (> (++ cnt) mxcnt) (setq mxcnt cnt) (setq times '()))
          (if (= cnt mxcnt) (push $2 times)))
        ("IN" (-- cnt))))
    (close handle)
    (list mxcnt times)))
