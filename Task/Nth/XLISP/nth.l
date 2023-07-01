(DEFUN NTH (N)
    (COND
        ((AND (> (MOD N 100) 3) (< (MOD N 100) 21)) `(,N TH))
        ((= (MOD N 10) 1) `(,N ST))
        ((= (MOD N 10) 2) `(,N ND))
        ((= (MOD N 10) 3) `(,N RD))
        (T `(,N TH))))

(DEFUN RANGE (X Y)
    (IF (<= X Y)
        (CONS X (RANGE (+ X 1) Y))))

(DEFUN TEST-NTH ()
    (DISPLAY (MAPCAR NTH (RANGE 1 25)))
    (NEWLINE)
    (DISPLAY (MAPCAR NTH (RANGE 250 265)))
    (NEWLINE)
    (DISPLAY (MAPCAR NTH (RANGE 1000 1025))))

(TEST-NTH)
