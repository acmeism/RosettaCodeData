(cffi:load-foreign-library "libcrypto.so")

(cffi:defcfun ("MD5" MD5) :void (string :string) (len :int) (ptr :pointer))

(let ((string-to-convert "The quick brown fox jumped over the lazy dog's back")
      (ptr (cffi:foreign-alloc :unsigned-char :count 16)))
  (md5 string-to-convert (length string-to-convert) ptr)
  (loop for i from 0 below 16 do
       (format t "~a" (write-to-string (cffi:mem-ref ptr :unsigned-char i) :base 16)))
  (cffi:foreign-free ptr))
