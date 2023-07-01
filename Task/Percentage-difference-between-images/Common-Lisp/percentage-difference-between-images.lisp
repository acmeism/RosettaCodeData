(require 'cl-jpeg)
;;; the JPEG library uses simple-vectors to store data. this is insane!
(defun compare-images (file1 file2)
  (declare (optimize (speed 3) (safety 0) (debug 0)))
  (multiple-value-bind (image1 height width) (jpeg:decode-image file1)
    (let ((image2 (jpeg:decode-image file2)))
      (loop for i of-type (unsigned-byte 8) across (the simple-vector image1)
            for j of-type (unsigned-byte 8) across (the simple-vector image2)
            sum (the fixnum (abs (- i j))) into difference of-type fixnum
            finally (return (coerce (/ difference width height #.(* 3 255))
                                    'double-float))))))

  CL-USER> (* 100 (compare-images "Lenna50.jpg" "Lenna100.jpg"))
  1.774856467652165d0
