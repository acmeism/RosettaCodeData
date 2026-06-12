(defvar latin-endings
  '(("are" . ("o" "as" "at" "amus" "atis" "ant"))
    ("ere" . ("o" "is" "it" "imus" "itis" "unt"))
    ("ēre" . ("eo" "es" "et" "emus" "etis" "ent"))
    ("ire" . ("io" "is" "it" "imus" "itis" "iunt")))
  "Endings for Latin verbs in present tense.")

(defun conjugate (latin-verb-infinitive)
  "Conjugate LATIN-VERB-INFINITIVE in present tense."
  (let* ((root-ending-position (- (length latin-verb-infinitive) 3))
         (verb-end (substring latin-verb-infinitive root-ending-position))
         (verb-root (substring latin-verb-infinitive 0 root-ending-position))
         (verb-endings (alist-get verb-end latin-endings nil nil 'equal)))
     (insert (format "\nconjugation of %s:\n" latin-verb-infinitive))
    (dolist (one-ending verb-endings)
      (insert (format "%s%s\n" verb-root one-ending)))))
