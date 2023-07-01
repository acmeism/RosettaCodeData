(setq *iban-code-length* '((15  ("NO"))
                             (16  ("BE"))
                             (18  ("DK" "FO" "FI" "GL" "NL"))
                             (19  ("MK" "SI"))
                             (20  ("AT" "BA" "EE" "KZ" "LT" "LU"))
                             (21  ("CR" "HR" "LV" "LI" "CH"))
                             (22  ("BH" "BG" "GE" "DE" "IE" "ME" "RS" "GB"))
                             (23  ("GI" "IL" "AE"))
                             (24  ("AD" "CZ" "MD" "PK" "RO" "SA" "SK" "ES" "SE" "TN" "VG"))
                             (25  ("PT"))
                             (26  ("IS" "TR"))
                             (27  ("FR" "GR" "IT" "MR" "MC" "SM"))
                             (28  ("AL" "AZ" "CY" "DO" "GT" "HU" "LB" "PL"))
                             (29  ("BR" "PS"))
                             (30  ("KW" "MU"))
                             (31  ("MT"))))


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Remove spaces and set upper case.
(define (sanitize-iban iban)
   (upper-case (replace " " iban ""))
)

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Check that only A-Z and 0-9 are used.
(define (valid-chars? iban)
	(setq rx (string "[A-Z0-9]{" (length iban) "}" ))
	(regex rx iban 1)
)

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Check that the length is correct for the country.
(define (valid-length? iban)
	(setq countries-found (lookup (int (length iban)) *iban-code-length*))
	(if (not (nil? countries-found))
		(member (0 2 iban) countries-found)
	)
)

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Convert the IBAN to integer following the rules from Wikipedia.
(define (iban-to-integer iban)
    (setq country-code (0 2 iban))
    (setq checksum (2 2 iban))
    (setq iban (string (4 iban) country-code))
    (setq iban (join (map (lambda (x) (if (regex "[0-9]" x) x (string (- (char x) 55)))) (explode iban))))
    (bigint (string iban checksum))
)

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Test if IBAN is correct (true) or not (nil):
;; (valid-iban? "GB82 WEST 1234 5698 7654 32") ==> true
;; (valid-iban? "GB82 TEST 1234 5698 7654 32") ==> nil
(define (valid-iban? iban)
    (setq iban (sanitize-iban iban))
    (and
        (valid-chars? iban)
        (valid-length? iban)
        (= 1L (% (iban-to-integer iban) 97))
    )
)
