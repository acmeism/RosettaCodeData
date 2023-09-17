(setq numbers '(one two three))
(setq shadings '(solid open striped))
(setq colours '(red green purple))
(setq symbols '(oval squiggle diamond))

(defun play ((n-cards . 9))
  (find-enough-sets n-cards (quotient n-cards 2)))

(defun find-enough-sets (n-cards enough (deal) (sets))
  (loop
    (setq deal (random-sample n-cards (deck)))
    (setq sets (find-sets deal))
    (while (lessp (length sets) enough)
      (show-cards deal)
      (printc)
      (show-sets sets))))

(defun show-cards (cards)
  (printc (length cards) '! cards)
  (map printc cards))

(defun show-sets (sets)
  (printc (length sets) '! sets)
  (map '(lambda (set)
          (printc)
          (map printc set))
       sets))

(defun find-sets (deal)
  (keep-if is-set (combinations 3 deal)))

(defun is-set (cards)
  (every feature-makes-set (transpose cards)))

(defun feature-makes-set (feature-values)
  (or (all-same feature-values)
      (all-different feature-values)))

(defun combinations (n items)
  (cond
    ((zerop n) '(()))
    ((null items) '())
    (t (append
          (mapc '(lambda (c) (cons (car items) c))
                (combinations (sub1 n) (cdr items)))
          (combinations n (cdr items))))))

'(  Making a deck  )

(defun deck ()
  ' ( The deck has to be made only once )
  (cond ((get 'deck 'cards))
        (t (put 'deck 'cards (make-deck)))))

(defun make-deck ()
  (add-feature numbers
    (add-feature shadings
      (add-feature colours
        (add-feature symbols
          (list '()))))))

(defun add-feature (values deck)
  (flatmap '(lambda (value)
               (mapc '(lambda (card) (cons value card))
                     deck))
           values))

'(  Utilities  )

(defun all-same (values)
  (every '(lambda (v) (eq v (car values)))
         values))

(defun all-different (values)
  (every '(lambda (v) (onep (count v values)))
         values))

(defun count (v values (n . 0))
  (loop (until (null values) n)
    (cond ((eq (car values) v) (setq n (add1 n))))
    (setq values (cdr values))))

(defun every (test suspects)
  (or (null suspects)
      (and (test (car suspects))
           (every test (cdr suspects)))))

(defun transpose (rows)
  (apply mapc (cons list rows)))

(defun reverse (list (result . ()))
  (map '(lambda (e) (setq result (cons e result)))
       list)
  result)

(defun append (a b)
  (reverse (reverse a) b))

(defun flatmap (_f_ _list_)
  (cond ((null _list_) '())
        (t (append (_f_ (car _list_))
                   (flatmap _f_ (cdr _list_))))))

(defun keep-if (_p_ _items_ (_to_keep_))
  (map '(lambda (_i_)
          (cond ((_p_ _i_)
                 (setq _to_keep_ (cons _i_ _to_keep_)))))
       _items_)
  (reverse _to_keep_))
