(defun thue-morse (n)
    (defun flip-bits (s)
        (defun flip (l)
            (if (not (null l))
                (cons
                    (if (equal (car l) #\1)
                        #\0
                        #\1)
                    (flip (cdr l)))))
        (list->string (flip (string->list s))))
    (if (= n 0)
        "0"
        (string-append (thue-morse (- n 1)) (flip-bits (thue-morse (- n 1))))))

; define RANGE, for testing purposes

(defun range (x y)
    (if (< x y)
        (cons x (range (+ x 1) y))))

; test THUE-MORSE by printing the strings it returns for n = 0 to n = 6

(mapcar (lambda (n) (print (thue-morse n))) (range 0 7))
