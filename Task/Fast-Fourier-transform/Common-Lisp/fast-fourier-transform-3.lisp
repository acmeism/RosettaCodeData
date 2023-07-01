;;; Demonstrates printing an FFT in both rectangular and polar form:
CL-USER> (mapc (lambda (c) (format t "~&~6F~6@Fi = ~6Fe^~6@Fipi"
                                   (realpart c) (imagpart c) (abs c) (/ (phase c) pi)))
               (fft '(1 1 1 1 0 0 0 0)))

   4.0  +0.0i =    4.0e^  +0.0ipi
   1.0-2.414i = 2.6131e^-0.375ipi
   0.0  +0.0i =    0.0e^  +0.0ipi
   1.0-0.414i = 1.0824e^-0.125ipi
   0.0  +0.0i =    0.0e^  +0.0ipi
   1.0+0.414i = 1.0824e^+0.125ipi
   0.0  +0.0i =    0.0e^  +0.0ipi
   1.0+2.414i = 2.6131e^+0.375ipi
;;; MAPC also returns the FFT data, which looks like this:
(#C(4.0 0.0) #C(1.0D0 -2.414213562373095D0) #C(0.0D0 0.0D0)
 #C(1.0D0 -0.4142135623730949D0) #C(0.0 0.0)
 #C(0.9999999999999999D0 0.4142135623730949D0) #C(0.0D0 0.0D0)
 #C(0.9999999999999997D0 2.414213562373095D0))
