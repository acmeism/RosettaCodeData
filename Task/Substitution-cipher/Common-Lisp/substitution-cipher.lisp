;
; substution.lsp
;
(defvar _original   "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
(defvar _substitute "dthnxkmqrwzseglyoaubjpcfivTKXMGVUPOIRFDEJZNYWCAQSLBH")
(defvar _text       "The quick brown fox jumps over the lazy dog!")

(defun encode (_plaintext _original _substitute)
  (map 'string
    #'(lambda (_char)
        (let*
          ((_offset (position _char _original)))
          (if _offset
            (aref _substitute _offset)
            _char)))
    _plaintext))

(print _text)
(setq _text (encode _text _original _substitute))
(print _text)
(setq _text (encode _text _substitute _original))
(print _text)

(exit)
