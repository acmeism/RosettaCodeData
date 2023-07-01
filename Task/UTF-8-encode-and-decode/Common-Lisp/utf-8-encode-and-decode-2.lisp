(defun unicode-to-utf-8 (int)
  "Take a unicode code point, return a list of one to four UTF-8 encoded bytes (octets)."
  (assert (<= (integer-length int) 21))
  (let ((n-trail-bytes (cond ((<= #x00000 int #x00007F) 0)
                             ((<= #x00080 int #x0007FF) 1)
                             ((<= #x00800 int #x00FFFF) 2)
                             ((<= #x10000 int #x10FFFF) 3)))
        (lead-templates (list #b00000000 #b11000000 #b11100000 #b11110000))
        (trail-template #b10000000)
        ;; number of content bits in the lead byte.
        (n-lead-bits (list 7 5 4 3))
        ;; number of content bits in the trail byte.
        (n-trail-bits 6)
        ;; list to put the UTF-8 encoded bytes in.
        (byte-list nil))
    (if (= n-trail-bytes 0)
        ;; if we need 0 trail bytes, ist just an ascii single byte.
        (push int byte-list)
        (progn
          ;; if we need more than one byte, first fill the trail bytes with 6 bits each.
          (loop for i from 0 to (1- n-trail-bytes)
             do (push (+ trail-template
                         (ldb (byte n-trail-bits (* i n-trail-bits)) int))
                      byte-list))
          ;; then copy the remaining content bytes to the lead byte.
          (push (+ (nth n-trail-bytes lead-templates)
                   (ldb (byte (nth n-trail-bytes n-lead-bits) (* n-trail-bytes n-trail-bits)) int))
                byte-list)))
    ;; return the list of UTF-8 encoded bytes.
    byte-list))
