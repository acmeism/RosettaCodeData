(defun utf-8-to-unicode (byte-list)
  "Take a list of one to four utf-8 encoded bytes (octets), return a code point."
  (let ((b1 (car byte-list)))
    (cond ((ascii-byte-p b1) b1) ; if a single byte, just return it.
          ((multi-byte-p b1)
           (if (lead-byte-p b1)
               (let ((n (n-trail-bytes b1))
                     ;; Content bits we want to extract from each lead byte.
                     (lead-templates (list #b01111111 #b00011111 #b00001111 #b00000111))
                     ;; Content bits we want to extract from each trail byte.
                     (trail-template #b00111111))
                 (if (= n (1- (list-length byte-list)))
                     ;; add lead byte
                     (+ (ash (logand (nth 0 byte-list) (nth n lead-templates)) (* 6 n))
                        ;; and the trail bytes
                        (loop for i from 1 to n sum
                             (ash (logand (nth i byte-list) trail-template) (* 6 (- n i)))))
                     (error "calculated number of bytes doesnt match the length of the byte list")))
               (error "first byte in the list isnt a lead byte"))))))
