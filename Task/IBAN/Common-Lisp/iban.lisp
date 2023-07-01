;;
;; List of the IBAN code lengths per country.
;;
(defvar *IBAN-code-length* '((15 . ("NO"))
                             (16 . ("BE"))
                             (18 . ("DK" "FO" "FI" "GL" "NL"))
                             (19 . ("MK" "SI"))
                             (20 . ("AT" "BA" "EE" "KZ" "LT" "LU"))
                             (21 . ("CR" "HR" "LV" "LI" "CH"))
                             (22 . ("BH" "BG" "GE" "DE" "IE" "ME" "RS" "GB"))
                             (23 . ("GI" "IL" "AE"))
                             (24 . ("AD" "CZ" "MD" "PK" "RO" "SA" "SK" "ES" "SE" "TN" "VG"))
                             (25 . ("PT"))
                             (26 . ("IS" "TR"))
                             (27 . ("FR" "GR" "IT" "MR" "MC" "SM"))
                             (28 . ("AL" "AZ" "CY" "DO" "GT" "HU" "LB" "PL"))
                             (29 . ("BR" "PS"))
                             (30 . ("KW" "MU"))
                             (31 . ("MT"))))

;;
;; The IBAN-character function verifies whether the number contains the correct characters only. There is
;; a built in function to verify for alphanumeric characters, but it includes characters beyond ASCII range.
;;
(defun IBAN-characters (iban)
  (flet ((valid-alphanum (ch)
           (or (and (char<= #\A ch)
                    (char>= #\Z ch))
               (and (char<= #\0 ch)
                    (char>= #\9 ch)))))
    (loop for char across iban
          always (valid-alphanum char))))

;;
;; The function IBAN-length verifies that the length of the number is correct. The code lengths
;; are retrieved from the table *IBAN-code-lengths*.
;;
(defun IBAN-length (iban)
  (loop :for  (len . country) :in *IBAN-code-length*
        :with iban-country = (subseq iban 0 2)
        :do
    (when (find iban-country country :test #'string=) (return (= len (length iban))))))

;;
;; The function IBAN-to-integer converts an IBAN code into an integer number.
;; Note: The conversion follows the rules stated in the wiki page.
;;
(defun IBAN-to-integer (iban)
  (let ((character-base (- (char-code #\A) 10)))
    (parse-integer
      (format nil "~{~a~}" (map 'list #'(lambda(X) (if (alpha-char-p X) (- (char-code X) character-base) X ))
                                      (concatenate 'string (subseq iban 4) (subseq iban 0 4)))))))
;;
;; The function IBAN-verify checks that the code contains right character set, has the
;; country specific length and has the correct check sum.
;;
(defun IBAN-verify (iban)
  (flet ((validp (X) (and (IBAN-characters X)
                          (IBAN-length X)
                          (= 1 (mod (IBAN-to-integer X) 97)))))
    (validp (remove #\Space iban))))
