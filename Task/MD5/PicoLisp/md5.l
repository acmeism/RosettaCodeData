(let Str "The quick brown fox jumped over the lazy dog's back"
   (pack
      (mapcar '((B) (pad 2 (hex B)))
         (native "libcrypto.so" "MD5" '(B . 16) Str (length Str) '(NIL (16))) ) ) )
