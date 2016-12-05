(lib 'types)
(lib 'plot)
(plot-size 512 512) ;; for example

;; use m = 16, 32, 44, .. to change the definition (number of losanges)
(define (plot-munch (m 256))
	(define PIX (pixels->int32-vector)) ;; get canvas image
	(define (pcolor x y) ;; color at (x,y)
		(hsv->rgb
			(// (bitwise-xor (modulo x m) (modulo y m)) m)
			0.9
			0.9))
	(pixels-map pcolor PIX)
	(vector->pixels PIX)) ;; draw canvas image

(plot-much) ;; ESC to see tge drawing
