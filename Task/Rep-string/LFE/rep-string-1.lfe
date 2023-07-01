(defun get-reps (text)
  (lists:filtermap
   (lambda (x)
     (case (get-rep text (lists:split x text))
       ('() 'false)
       (x `#(true ,x))))
   (lists:seq 1 (div (length text) 2))))

(defun get-rep
  ((text `#(,head ,tail))
   (case (string:str text tail)
     (1 head)
     (_ '()))))
