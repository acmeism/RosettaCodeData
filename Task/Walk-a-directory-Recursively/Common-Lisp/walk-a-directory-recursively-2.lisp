CL-USER> (mapc-directory-tree (lambda (x)
                                (when (equal (pathname-type x) "lisp")
                                  (write-line (namestring x))))
                              "lang/")
/home/sthalik/lang/lisp/.#bitmap.lisp
/home/sthalik/lang/lisp/avg.lisp
/home/sthalik/lang/lisp/bitmap.lisp
/home/sthalik/lang/lisp/box-muller.lisp
/home/sthalik/lang/lisp/displaced-subseq.lisp
[...]
