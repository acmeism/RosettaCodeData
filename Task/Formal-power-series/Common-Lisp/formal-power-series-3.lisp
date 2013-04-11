(defstruct lons
  lar
  ldr)

(defun lar (lons)
  (lons-lar lons))

(defun ldr (lons)
  (if (not (promise-p (lons-ldr lons)))
    (lons-ldr lons)
    (setf (lons-ldr lons)
          (force (lons-ldr lons)))))

(defmacro lons (lar ldr)
  `(make-lons :lar ,lar :ldr (delay ,ldr)))
