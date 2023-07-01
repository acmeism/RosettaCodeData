CL-USER> (let ((list '())
               (hash-table (make-hash-table)))
           (push 1 list)
           (push 2 list)
           (push 3 list)
           (format t "~S~%" (reverse list))
           (setf (gethash 'foo hash-table) 42)
           (setf (gethash 'bar hash-table) 69)
           (maphash (lambda (key value)
                      (format t "~S => ~S~%" key value))
                    hash-table)
           ;; or print the hash-table in readable form
           ;; (inplementation-dependent)
           (write hash-table :readably t)
           ;; or describe it
           (describe hash-table)
           ;; describe the list as well
           (describe list))
;; FORMAT on a list
(1 2 3)
;; FORMAT on a hash-table
FOO => 42
BAR => 69
;; WRITE :readably t on a hash-table
#.(SB-IMPL::%STUFF-HASH-TABLE
   (MAKE-HASH-TABLE :TEST 'EQL :SIZE '16 :REHASH-SIZE '1.5
                    :REHASH-THRESHOLD '1.0 :WEAKNESS 'NIL)
   '((BAR . 69) (FOO . 42)))
;; DESCRIBE on a hash-table
#<HASH-TABLE :TEST EQL :COUNT 2 {1002B6F391}>
  [hash-table]

Occupancy: 0.1
Rehash-threshold: 1.0
Rehash-size: 1.5
Size: 16
Synchronized: no
;; DESCRIBE on a list
(3 2 1)
  [list]
; No value
