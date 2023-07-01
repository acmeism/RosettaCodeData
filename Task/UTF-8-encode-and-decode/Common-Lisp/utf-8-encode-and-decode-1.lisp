(defun ascii-byte-p (octet)
  "Return t if octet is a single-byte 7-bit ASCII char.
  The most significant bit is 0, so the allowed pattern is 0xxx xxxx."
  (assert (typep octet 'integer))
  (assert (<= (integer-length octet) 8))
  (let ((bitmask  #b10000000)
        (template #b00000000))
    ;; bitwise and the with the bitmask #b11000000 to extract the first two bits.
    ;; check if the first two bits are equal to the template #b10000000.
    (= (logand bitmask octet) template)))

(defun multi-byte-p (octet)
  "Return t if octet is a part of a multi-byte UTF-8 sequence.
  The multibyte pattern is 1xxx xxxx. A multi-byte can be either a lead byte or a trail byte."
  (assert (typep octet 'integer))
  (assert (<= (integer-length octet) 8))
  (let ((bitmask  #b10000000)
        (template #b10000000))
    ;; bitwise and the with the bitmask #b11000000 to extract the first two bits.
    ;; check if the first two bits are equal to the template #b10000000.
    (= (logand bitmask octet) template)))

(defun lead-byte-p (octet)
  "Return t if octet is one of the leading bytes of an UTF-8 sequence, nil otherwise.
  Allowed leading byte patterns are 0xxx xxxx, 110x xxxx, 1110 xxxx and 1111 0xxx."
  (assert (typep octet 'integer))
  (assert (<= (integer-length octet) 8))
  (let ((bitmasks  (list #b10000000 #b11100000 #b11110000 #b11111000))
        (templates (list #b00000000 #b11000000 #b11100000 #b11110000)))
    (some #'(lambda (a b) (= (logand a octet) b)) bitmasks templates)))

(defun n-trail-bytes (octet)
  "Take a leading utf-8 byte, return the number of continuation bytes 1-3."
  (assert (typep octet 'integer))
  (assert (<= (integer-length octet) 8))
  (let ((bitmasks  (list #b10000000 #b11100000 #b11110000 #b11111000))
        (templates (list #b00000000 #b11000000 #b11100000 #b11110000)))
    (loop for i from 0 to 3
       when (= (nth i templates) (logand (nth i bitmasks) octet))
       return i)))
