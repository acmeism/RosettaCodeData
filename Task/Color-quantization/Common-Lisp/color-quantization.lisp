(defpackage #:quantize
  (:use #:cl
        #:opticl))

(in-package #:quantize)

(defun image->pixels (image)
  (check-type image 8-bit-rgb-image)
  (let (pixels)
    (do-pixels (y x) image
      (push (pixel* image y x) pixels))
    pixels))

(defun greatest-color-range (pixels)
  (loop for (r g b) in pixels
        minimize r into r-min
        minimize g into g-min
        minimize b into b-min
        maximize r into r-max
        maximize g into g-max
        maximize b into b-max
        finally
           (return (let* ((r-range (- r-max r-min))
                          (g-range (- g-max g-min))
                          (b-range (- b-max b-min))
                          (max-range (max r-range g-range b-range)))
                     (cond ((= r-range max-range) 0)
                           ((= g-range max-range) 1)
                           (t                     2))))))

(defun median-cut (pixels target-num-colors)
  (assert (zerop (mod (log target-num-colors 2) 1)))
  (if (or (= target-num-colors 1) (null (rest pixels)))
      (list pixels)
      (let* ((channel (greatest-color-range pixels))
             (sorted (sort pixels #'< :key (lambda (pixel) (nth channel pixel))))
             (half (floor (length sorted) 2))
             (next-target (/ target-num-colors 2)))
        (nconc (median-cut (subseq sorted 0 half) next-target)
               (median-cut (subseq sorted half) next-target)))))

(defun quantize-colors (pixels target-num-colors)
  (let ((color-map (make-hash-table :test #'equal)))
    (dolist (bucket (median-cut pixels target-num-colors) color-map)
      (loop for (r g b) in bucket
            sum r into r-sum
            sum g into g-sum
            sum b into b-sum
            count t into num-pixels
            finally (let ((average (list (round r-sum num-pixels)
                                         (round g-sum num-pixels)
                                         (round b-sum num-pixels))))
                      (dolist (pixel bucket)
                        (setf (gethash pixel color-map) average)))))))

(defun quantize-image (input-file output-file target-num-colors)
  (let* ((image (read-png-file input-file))
         (pixels (image->pixels image))
         (color-map (quantize-colors pixels target-num-colors))
         (result-image (with-image-bounds (height width) image
                         (make-8-bit-rgb-image height width :initial-element 0))))
    (set-pixels (y x) result-image
      (let* ((original (multiple-value-list (pixel image y x)))
             (quantized (gethash original color-map)))
        (values-list quantized)))
    (write-png-file output-file result-image)))
