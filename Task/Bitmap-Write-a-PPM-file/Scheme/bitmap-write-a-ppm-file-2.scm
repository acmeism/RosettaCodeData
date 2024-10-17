(define image (make-image 800 600))
(image-fill! image *black*)
(image-set! image 400 300 *blue*)
(write-ppm image "out.ppm")
