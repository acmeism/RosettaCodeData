(flet ((do-case (converter)
         ;; A = 10, B = 11, ... Z = 35
         (loop for radix from 10 to 35
            for char = (funcall converter (digit-char radix 36)) do
              (format t "~&~8D  #\\~24A  ~S"
                      ;; The codes and names vary across systems
                      (char-code char) (char-name char) char))))
  (format t "~&;;; Code       Full Name       Appearance")
  ;; Using a local function reduces code duplication
  (do-case #'char-downcase) (do-case #'char-upcase))
