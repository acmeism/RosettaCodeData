(require 'seq)

(defun luhn (str)
  "Check if STR is a valid credit card number using the Luhn algorithm."
  (if (string-match-p "[^0-9]" str)
      (error "String contains invalid character")
    (let ((digit-list (reverse (mapcar #'(lambda (x) (- x 48))
                                         (string-to-list str)))))
        (zerop
         (mod (apply #'+ (seq-map-indexed
                          (lambda (elt idx)
                            (if (not (zerop (% idx 2)))
                                (if (> (* 2 elt) 9)
                                    (- (* 2 elt) 9)
                                  (* 2 elt))
                              elt))
                          digit-list))
              10)))))

(mapcar #'luhn '("49927398716" "49927398717" "1234567812345678" "1234567812345670"))
