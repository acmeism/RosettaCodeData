(setq alphabet "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
(setq code     "odrmqbjnwzvueghlacyfpktisxODRMQBJNWZVUEGHLACYFPKTISX")

(defun encode (text)
  "Encode TEXT with simple substitution code.
Each letter is replaced with the a random letter.
A specific letter in the original will always be replaced
by the same coded letter."
  (let* ((case-fold-search nil)
	(text-length (length text))
	(encoded-text "")
	(current-letter "")
	(coded-letter "")
	(alphabet-position))
    (dotimes (i text-length)
      (setq current-letter (substring text i (+ 1 i)))			    ; find the next letter in TEXT
      (if (not (string-match-p "[a-zA-Z]" current-letter))		    ; IF it's not a letter
	  (setq coded-letter current-letter)						    ; pass the non-letter without change
	(setq alphabet-position (string-match current-letter alphabet))	; ELSE find where the letter is in ALPHABET
	(setq coded-letter (substring code alphabet-position (+ 1 alphabet-position)))) ; AND pass the coded letter
      (setq encoded-text (concat encoded-text coded-letter)))		; IN ANY CASE, add new letter to ENCODED-TEXT
    encoded-text))

(defun decode (text)
  "Decode TEXT encoded with simple substitution code.
Each coded letter is replaced with the corresponding
uncoded letter."
  (let* ((case-fold-search nil)
	(text-length (length text))
	(uncoded-text "")
	(current-letter "")
	(uncoded-letter "")
	(code-position))
    (dotimes (i text-length)
      (setq current-letter (substring text i (+ 1 i)))					          ; find the next letter in TEXT
      (if (not (string-match-p "[a-zA-Z]" current-letter))				          ; IF it's not a letter
	  (setq uncoded-letter current-letter)						                  ; pass the non-letter without change
	(setq code-position (string-match current-letter code))				          ; ELSE find where the letter is in CODE
	(setq uncoded-letter (substring alphabet code-position (+ 1 code-position)))) ; AND pass the uncoded letter
      (setq uncoded-text (concat uncoded-text uncoded-letter)))				      ; IN ANY CASE, add new letter to UNCODED-TEXT
    uncoded-text))
