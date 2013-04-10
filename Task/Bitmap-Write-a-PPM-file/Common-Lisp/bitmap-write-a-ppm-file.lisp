(defun write-rgb-buffer-to-ppm-file (filename buffer)
  (with-open-file (stream filename
			  :element-type '(unsigned-byte 8)
			  :direction :output
			  :if-does-not-exist :create
			  :if-exists :supersede)
    (let* ((dimensions (array-dimensions buffer))
	   (width (first dimensions))
	   (height (second dimensions))
	   (header (format nil "P6~A~D ~D~A255~A"
			   #\newline
			   width height #\newline
			   #\newline)))
      (loop
	 :for char :across header
	 :do (write-byte (char-code char) stream)) #| Assumes char-codes match ASCII |#

      (loop
	 :for x :upfrom 0 :below width
	 :do (loop :for y :upfrom 0 :below height
		:do (let ((pixel (rgb-pixel buffer x y)))
		      (let ((red (rgb-pixel-red pixel))
			    (green (rgb-pixel-green pixel))
			    (blue (rgb-pixel-blue pixel)))
			(write-byte red stream)
			(write-byte green stream)
			(write-byte blue stream)))))))
  filename)
