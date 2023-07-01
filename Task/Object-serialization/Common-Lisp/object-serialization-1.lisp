(defmacro with-serialization-to-file ((stream pathname) &body body)
  `(with-open-file (,stream ,pathname
                            :element-type '(unsigned-byte 8)
                            :direction :output
                            :if-exists :supersede)
     ,@body))

(defclass entity ()
  ((name :initarg :name :initform "Some entity")))

(defclass person (entity)
  ((name :initarg :name :initform "The Nameless One")))
