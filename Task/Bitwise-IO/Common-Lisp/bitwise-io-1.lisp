(defpackage :rosetta.bitwise-i/o
  (:use :common-lisp)
  (:export :bitwise-i/o-demo))
(in-package :rosetta.bitwise-i/o)

(defun byte->bit-vector (byte byte-bits)
  "Convert one BYTE into a bit-vector of BYTE-BITS length."
  (let ((vector (make-array byte-bits :element-type 'bit))
        (bit-value 1))
    (declare (optimize (speed 3)))
    (dotimes (bit-index byte-bits vector)
      (setf (aref vector bit-index)
            (if (plusp (logand byte (the (unsigned-byte 8) bit-value)))
                1 0))
      (setq bit-value (ash bit-value 1)))))

(defun bytes->bit-vector (byte-vector byte-bits)
  "Convert a BYTE-VECTOR into a bit-vector, with each byte taking BYTE-BITS.

For  optimization's sake,  I  limit the  size of  the  vector to  (FLOOR
MOST-POSITIVE-FIXNUM  BYTE-BITS), which  is somewhat  ridiculously long,
but allows the compiler to trust that indices will fit in a FIXNUM."
  (reduce (lambda (a b) (concatenate 'bit-vector a b))
          (map 'list (lambda (byte) (byte->bit-vector byte byte-bits)) byte-vector)))

(defun ascii-char-p (char)
  "True if CHAR is an ASCII character"
  (< (char-code char) #x80))

(defun assert-ascii-string (string)
  "`ASSERT' that STRING is an ASCII string."
  (assert (every #'ascii-char-p string)
          (string)
          "STRING must contain only ASCII (7-bit) characters;~%“~a”
…contains non-ASCII character~p~:*: ~{~% • ~c ~:*— ~@c ~}"
          string (coerce (remove-duplicates (remove-if #'ascii-char-p string)
                                            :test #'char=)
                         'list)))

(defun ascii-string->bit-vector (string)
  "Convert a STRING consisting only  of characters in the ASCII \(7-bit)
range into a bit-vector of 7 bits per character.

This assumes \(as is now, in  2017, I believe universally the case) that
the local character code system \(as for `CHAR-CODE' and `CODE-CHAR') is
Unicode, or at least, a superset of ASCII \(eg: ISO-8859-*)
"
  (check-type string simple-string)
  (assert-ascii-string string)
  (bytes->bit-vector (map 'vector #'char-code string) 7))

(defun pad-bit-vector-to-8 (vector)
  "Ensure that VECTOR is a multiple of 8 bits in length."
  (adjust-array vector (* 8 (ceiling (length vector) 8))))

(defun bit-vector->byte (vector)
  "Convert VECTOR into a single byte."
  (declare (optimize (speed 3)))
  (check-type vector bit-vector)
  (assert (<= (length vector) 8))
  (reduce (lambda (x y)
            (logior (the (unsigned-byte 8)
                         (ash (the (unsigned-byte 8) x) 1))
                    (the bit y)))
          (reverse vector) :initial-value 0))

(defun bit-vector->bytes (vector byte-size &key (truncatep nil))
  "Convert a bit vector VECTOR into a vector of bytes of BYTE-SIZE bits each.

If TRUNCATEP, then discard any trailing bits."
  (let* ((out-length (funcall (if truncatep 'floor 'ceiling)
                              (length vector)
                              byte-size))
         (output (make-array out-length
                             :element-type (list 'unsigned-byte byte-size))))
    (loop for byte from 0 below out-length
          for start-bit = 0 then end-bit
          for end-bit = byte-size then (min (+ byte-size end-bit)
                                            (length vector))
          do (setf (aref output byte)
                   (bit-vector->byte (subseq vector start-bit end-bit))))
    output))

(defun ascii-pack-to-8-bit (string)
  "Pack an ASCII STRING into 8-bit bytes (7→8 bit packing)"
  (bit-vector->bytes (ascii-string->bit-vector string)
                     8))

(defun unpack-ascii-from-8-bits (byte-vector)
  "Convert an 8-bit BYTE-VECTOR into an array of (unpacked) 7-bit bytes."
  (map 'string #'code-char
       (bit-vector->bytes
        (pad-bit-vector-to-8 (bytes->bit-vector byte-vector 8))
        7
        :truncatep t)))

(defun write-7->8-bit-string-to-file (string pathname)
  "Given a string of 7-bit character STRING, create a new file at PATHNAME
with the contents of that string packed into 8-bit bytes."
  (format *trace-output* "~&Writing string to ~a in packed 7→8 bits…~%“~a”"
          pathname string)
  (assert-ascii-string string)
  (with-open-file (output pathname
                          :direction :output
                          :if-exists :supersede
                          :element-type '(unsigned-byte 8))
    (write-sequence (ascii-pack-to-8-bit string) output)
    (finish-output output)
    (let ((expected-length (ceiling (* (length string) 7) 8)))
      (assert (= (file-length output) expected-length) ()
              "The file written was ~:d byte~:p in length, ~
but the string supplied should have written ~:d byte~:p."
              (file-length output) expected-length))))

(defun read-file-into-byte-array (pathname)
  "Read a binary file into a byte array"
  (with-open-file (input pathname
                         :direction :input
                         :if-does-not-exist :error
                         :element-type '(unsigned-byte 8))
    (let ((buffer (make-array (file-length input)
                              :element-type '(unsigned-byte 8))))
      (read-sequence buffer input)
      buffer)))

(defun read-8->7-bit-string-from-file (pathname)
  "Read   8-bit   packed  data   from   PATHNAME   and  return   it   as
a 7-bit string."
  (unpack-ascii-from-8-bits (read-file-into-byte-array pathname)))

(defun bitwise-i/o-demo (&key (string "Hello, World.")
                              (pathname #p"/tmp/demo.bin"))
  "Writes STRING  to PATHNAME after  7→8 bit  packing, then reads  it back
to validate."
  (write-7->8-bit-string-to-file string pathname)
  (let ((read-back (read-8->7-bit-string-from-file pathname)))
    (assert (equal string read-back) ()
            "Reading back string got:~%“~a”~%…expected:~%“~a”" read-back string)
    (format *trace-output* "~&String read back matches:~%“~a”" read-back))
  (finish-output *trace-output*))
