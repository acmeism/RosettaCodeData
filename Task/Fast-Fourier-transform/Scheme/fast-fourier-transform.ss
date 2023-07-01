; Compute and return the FFT of the given input vector using the Cooley-Tukey Radix-2
; Decimation-in-Time (DIT) algorithm.  The input is assumed to be a vector of complex
; numbers that is a power of two in length greater than zero.

(define fft-r2dit
  (lambda (in-vec)
    ; The constant ( -2 * pi * i ).
    (define -2*pi*i (* -2.0i (atan 0 -1)))
    ; The Cooley-Tukey Radix-2 Decimation-in-Time (DIT) procedure.
    (define fft-r2dit-aux
      (lambda (vec start leng stride)
        (if (= leng 1)
          (vector (vector-ref vec start))
          (let* ((leng/2 (truncate (/ leng 2)))
                 (evns (fft-r2dit-aux vec 0 leng/2 (* stride 2)))
                 (odds (fft-r2dit-aux vec stride leng/2 (* stride 2)))
                 (dft (make-vector leng)))
            (do ((inx 0 (1+ inx)))
                ((>= inx leng/2) dft)
              (let ((e (vector-ref evns inx))
                    (o (* (vector-ref odds inx) (exp (* inx (/ -2*pi*i leng))))))
                (vector-set! dft inx (+ e o))
                (vector-set! dft (+ inx leng/2) (- e o))))))))
    ; Call the Cooley-Tukey Radix-2 Decimation-in-Time (DIT) procedure w/ appropriate
    ; arguments as derived from the argument to the fft-r2dit procedure.
    (fft-r2dit-aux in-vec 0 (vector-length in-vec) 1)))

; Test using a simple pulse.

(let* ((inp (vector 1.0 1.0 1.0 1.0 0.0 0.0 0.0 0.0))
       (dft (fft-r2dit inp)))
  (printf "In:  ~a~%" inp)
  (printf "DFT: ~a~%" dft))
