(defun strip-chars (str chars)
  (remove-if (lambda (ch) (find ch chars)) str))

(strip-chars "She was a soul stripper. She took my heart!" "aei")
;; => "Sh ws  soul strppr. Sh took my hrt!"
