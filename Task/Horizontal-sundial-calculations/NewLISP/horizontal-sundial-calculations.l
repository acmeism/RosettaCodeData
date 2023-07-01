(define pi 3.141592654)
(define (radians degrees) (mul degrees (div pi 180)))
(define (degrees radians) (mul radians (div 180 pi)))

(print "Enter latitude       => ")
(set 'lat (float (read-line)))

(print "Enter longitude      => ")
(set 'lng (float (read-line)))

(print "Enter legal meridian => ")
(set 'rf (float (read-line)))

(println)

(set 'slat (sin (radians lat)))

(println (format "    sine of latitude:   %.3f" slat))
(println (format "    diff longitude:     %.3f" (sub lng rf)))
(println)
(println "Hour, sun hour angle, dial hour line angle from 6am to 6pm")

(for (h -6 6)
	(set 'hra (sub (mul 15 h) lng rf))
	(set 'hla (degrees (atan (mul slat (tan (radians hra))))))
	(println (format "HR=%3d; HRA=%7.3f; HLA=%7.3f" h hra hla))
)

(exit)
