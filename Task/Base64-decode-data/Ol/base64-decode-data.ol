(define base64-codes "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")
(define kernel (alist->ff (map cons (string->bytes base64-codes) (iota (string-length base64-codes)))))

; returns n bits from input binary stream
(define (bits n hold)
   (let loop ((hold hold))
      (vector-apply hold (lambda (v i l)
         (cond
            ((null? l)
               (values (>> v (- i n)) #false))
            ((pair? l)
               (if (not (less? i n))
                  (values (>> v (- i n)) (vector (band v (- (<< 1 (- i n)) 1)) (- i n) l))
                  (loop (vector
                     (bor (<< v 6) (kernel (car l) 0))
                     (+ i 6)
                     (unless (eq? (car l) "=") (cdr l))))))
            (else
               (loop (vector v i (l)))))))))

; decoder.
(define (decode str)
   (print "decoding string '" str "':")
   (let loop ((hold [0 0 (str-iter str)]))
      (let*((bit hold (bits 8 hold)))
         (unless (zero? bit) (display (string bit)))
         (when hold
            (loop hold))))
   (print)(print))

; TESTING
(decode "SGVsbG8sIExpc3Ah")

(decode "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLSBQYXVsIFIuIEVocmxpY2g=")

(decode "TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlzIHNpbmd1bGFyIHBhc3Npb24gZnJvbSBvdGhlciBhbmltYWxzLCB3aGljaCBpcyBhIGx1c3Qgb2YgdGhlIG1pbmQsIHRoYXQgYnkgYSBwZXJzZXZlcmFuY2Ugb2YgZGVsaWdodCBpbiB0aGUgY29udGludWVkIGFuZCBpbmRlZmF0aWdhYmxlIGdlbmVyYXRpb24gb2Yga25vd2xlZGdlLCBleGNlZWRzIHRoZSBzaG9ydCB2ZWhlbWVuY2Ugb2YgYW55IGNhcm5hbCBwbGVhc3VyZS4=")
