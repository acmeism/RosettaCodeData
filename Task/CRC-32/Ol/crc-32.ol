(define (crc32 str)
   (bxor #xFFFFFFFF
      (fold (lambda (crc char)
               (let loop ((n 8) (crc crc) (bits char))
                  (if (eq? n 0)
                     crc
                     (let*((flag (band (bxor bits crc) 1))
                           (crc (>> crc 1))
                           (crc (if (eq? flag 0) crc (bxor crc #xEDB88320)))
                           (bits (>> bits 1)))
                        (loop (- n 1) crc bits)))))
         #xFFFFFFFF
         (string->list str))))

(print (number->string (crc32 "The quick brown fox jumps over the lazy dog") 16))
(print (number->string (crc32 (list->string (repeat #x00 32))) 16))
(print (number->string (crc32 (list->string (repeat #xFF 32))) 16))
(print (number->string (crc32 (list->string (iota 32))) 16))
