(define (monotonic-slices lst key-func (cmp =))
  (let (result '()  tmp '()  old-key 0  new-key 0)
    (dolist (x lst)
      (set 'new-key (key-func x))
      (cond ((empty? tmp) (push x tmp))
            ((cmp new-key old-key) (push x tmp))
            (true (push (reverse tmp) result) (set 'tmp (list x))))
      (set 'old-key new-key))
    (unless (empty? tmp) (push (reverse tmp) result))
    (reverse result)))

(monotonic-slices '(0 2 3 4 5 7) odd?)
  ===>
((0 2) (3) (4) (5 7))

(monotonic-slices '(0 2 3 3 4 8 7 9) or >)
  ===>
((0 2 3) (3 4 8) (7 9))
