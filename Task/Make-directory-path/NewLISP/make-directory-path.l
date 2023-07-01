(define (mkdir-p mypath)
    (if (= "/" (mypath 0)) ;; Abs or relative path?
        (setf /? "/")
        (setf /? "")
    )
    (setf path-components (clean empty? (parse mypath "/"))) ;; Split path and remove empty elements
    (for (x 0 (length path-components))
        (setf walking-path (string /? (join (slice path-components 0 (+ 1 x)) "/")))
        (make-dir walking-path)
    )
)

;; Using user-made function...
(mkdir-p "/tmp/rosetta/test1")

;; ... or calling OS command directly.
(! "mkdir -p /tmp/rosetta/test2")
(exit)
