;; Helper function for creating the rules table
(defun make-rules-table (rules-list)
  (let ((rules (make-hash-table :test 'equal)))
    (loop for (state content new-content dir new-state) in rules-list
          do (setf (gethash (cons state content) rules)
                   (list new-state new-content dir)))
    rules))

(format T "Simple incrementer~%")
(turing 'q0 'qf 'B (make-rules-table '((q0 1 1 right q0) (q0 B 1 stay qf))) '(1 1 1) T)

(format T "Three-state busy beaver~%")
(turing 'a 'halt 0
        (make-rules-table '((a 0 1 right b)
                            (a 1 1 left c)
                            (b 0 1 left a)
                            (b 1 1 right b)
                            (c 0 1 left b)
                            (c 1 1 stay halt)))
        '() T)

(format T "Sort (final tape)~%")
(format T "~{~a~}~%"
        (turing 'A 'H 0
                (make-rules-table '((A 1 1 right A)
                                    (A 2 3 right B)
                                    (A 0 0 left E)
                                    (B 1 1 right B)
                                    (B 2 2 right B)
                                    (B 0 0 left C)
                                    (C 1 2 left D)
                                    (C 2 2 left C)
                                    (C 3 2 left E)
                                    (D 1 1 left D)
                                    (D 2 2 left D)
                                    (D 3 1 right A)
                                    (E 1 1 left E)
                                    (E 0 0 right H)))
                '(2 1 2 2 2 1 1)))

(format T "5-state busy beaver (first 20 cells)~%")
(format T "~{~a~}...~%"
  (subseq (turing 'A 'H 0
                  (make-rules-table '((A 0 1 right B)
                                      (A 1 1 left  C)
                                      (B 0 1 right C)
                                      (B 1 1 right B)
                                      (C 0 1 right D)
                                      (C 1 0 left E)
                                      (D 0 1 left A)
                                      (D 1 1 left D)
                                      (E 0 1 stay H)
                                      (E 1 0 left A)))
                  '())
          0 20))
