(let ((string "I am a string"))
  (multiple-value-bind (string matchp)
      (cl-ppcre:regex-replace "\\bam\\b" string "was")
    (when matchp
      (write-line "I was able to find and replace 'am' with 'was'."))))
