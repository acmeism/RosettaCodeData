(defun ks (max-w items)
  (let ((cache (make-vector (1+ (length items)) nil)))
    (dotimes (n (1+ (length items)))
      (setf (aref cache n) (make-hash-table :test 'eql)))
    (defun ks-emb (spc items)
      (let ((slot (gethash spc (aref cache (length items)))))
        (cond
         ((null items) (list 0 0 '()))
         (slot slot)
         (t (puthash spc
                  (let*
                      ((i (car items))
                       (w (nth 1 i))
                       (v (nth 2 i))
                       (x (ks-emb spc (cdr items))))
                    (cond
                     ((> w spc) x)
                     (t
                      (let* ((y (ks-emb (- spc w) (cdr items)))
                             (v (+ v (car y))))
                        (cond
                         ((< v (car x)) x)
                         (t
                          (list v (+ w (nth 1 y)) (cons i (nth 2 y)))))))))
                  (aref cache (length items)))))))
    (ks-emb max-w items)))

(ks 400
    '((map 9 150) (compass 13 35) (water 153 200) (sandwich 50 160)
      (glucose 15 60) (tin 68 45)(banana 27 60) (apple 39 40)
      (cheese 23 30) (beer 52 10) (cream 11 70) (camera 32 30)
      (T-shirt 24 15) (trousers 48 10) (umbrella 73 40)
      (waterproof-trousers 42 70) (overclothes 43 75) (notecase 22 80)
      (glasses 7 20) (towel 18 12) (socks 4 50) (book 30 10)))
