;; Since newLISP has dynamic scope, use a namespace or context
;; to avoid variable capture.
(context 'monotonic-slices)
(define (monotonic-slices:monotonic-slices lst (key-func or) (cmp =))
  (let (result '()  tmp '()  old-key 0  new-key 0)
    (dolist (x lst)
      (set 'new-key (key-func x))
      (cond ((empty? tmp) (push x tmp -1))
            ((cmp new-key old-key) (push x tmp -1))
            (true (push tmp result) (set 'tmp (list x))))
      (set 'old-key new-key))
    (unless (empty? tmp) (push tmp result))
    (reverse result)))
(context MAIN)

(monotonic-slices
  (sort (explode (string "133252abcdeeffd" "a6789798st" "yxcdfgxcyz"))))

(("1") ("2" "2") ("3" "3") ("5") ("6") ("7" "7") ("8" "8") ("9" "9")
 ("a" "a") ("b") ("c" "c" "c") ("d" "d" "d") ("e" "e") ("f" "f" "f")
 ("g") ("s") ("t") ("x" "x") ("y" "y") ("z"))

(join (flat (clean 1
  (monotonic-slices
    (sort (explode (string "133252abcdeeffd" "a6789798st" "yxcdfgxcyz")))))))

"156bgstz"
