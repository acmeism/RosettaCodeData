(defparameter *earth-radius* 6372.8)

(defparameter *rad-conv* (/ pi 180))

(defun deg->rad (x)
  (* x *rad-conv*))

(defun haversine (x)
  (expt (sin (/ x 2)) 2))

(defun dist-rad (lat1 lng1 lat2 lng2)
  (let* ((hlat (haversine (- lat2 lat1)))
         (hlng (haversine (- lng2 lng1)))
         (root (sqrt (+ hlat (* (cos lat1) (cos lat2) hlng)))))
    (* 2 *earth-radius* (asin root))))

(defun dist-deg (lat1 lng1 lat2 lng2)
  (dist-rad (deg->rad lat1)
            (deg->rad lng1)
            (deg->rad lat2)
            (deg->rad lng2)))
