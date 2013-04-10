(in-package #:rgb-pixel-buffer)

(defparameter *whitespaces-chars* '(#\SPACE #\RETURN #\TAB #\NEWLINE #\LINEFEED))

(defun read-header-chars (stream &optional (delimiter-list *whitespaces-chars*))
  (do ((c (read-char stream nil :eof)
          (read-char stream nil :eof))
       (vals nil (if (or (null c) (char= c  #\#)) vals (cons c vals))))   ;;don't collect comment chars
       ((or (eql c :eof) (member c delimiter-list)) (map 'string #'identity (nreverse vals)))   ;;return strings
    (when (char= c #\#)   ;;skip comments
      (read-line stream))))

(defun read-ppm-file-header (file)
  (with-open-file (s file :direction :input)
    (do ((failure-count 0 (1+ failure-count))
	 (tokens nil (let ((t1 (read-header-chars s)))
		       (if (> (length t1) 0)
			   (cons t1 tokens)
			   tokens))))
	((>= (length tokens) 4) (values (nreverse tokens)
			      (file-position s)))
      (when (>= failure-count 10)
	(error (format nil "File ~a does not seem to be a proper ppm file - maybe too many comment lines" file)))
      (when (= (length tokens) 1)
	(when (not (or (string= (first tokens) "P6") (string= (first tokens) "P3")))
	  (error (format nil "File ~a is not a ppm file - wrong magic-number. Read ~a instead of P6 or P3 " file (first tokens))))))))

(defun read-ppm-image (file)
  (flet ((image-data-reader (stream start-position width height image-build-function read-function)
	   (file-position stream start-position)
	   (dotimes (row height)
	     (dotimes (col width)
	       (funcall image-build-function row col (funcall read-function stream))))))
    (multiple-value-bind (header file-pos) (read-ppm-file-header file)
      (let* ((image-type (first header))
	     (width (parse-integer (second header) :junk-allowed t))
	     (height (parse-integer (third header) :junk-allowed t))
	     (max-value (parse-integer (fourth header) :junk-allowed t))
	     (image (make-rgb-pixel-buffer width height)))
	(when (> max-value 255)
	  (error "unsupported depth - convert to 1byte depth with pamdepth"))
	(cond ((string= "P6" image-type)
	       (with-open-file (stream file :direction :input :element-type '(unsigned-byte 8))
		 (image-data-reader stream
				    file-pos
				    width
				    height
				    #'(lambda (w h val)
					(setf (rgb-pixel image w h) val))
				    #'(lambda (stream)
					(make-rgb-pixel (read-byte stream)
							(read-byte stream)
							(read-byte stream))))
		 image))
	      ((string= "P3" image-type)
	       (with-open-file (stream file :direction :input)
		 (image-data-reader stream
				    file-pos
				    width
				    height
				    #'(lambda (w h val)
					(setf (rgb-pixel image w h) val))
				    #'(lambda (stream)
					(make-rgb-pixel (read stream)
							(read stream)
							(read stream))))
		 image))
	      (t 'unsupported))
      image))))

(export 'read-ppm-image)
