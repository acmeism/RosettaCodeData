(let Str "Rosetta Code"
   (pack
      (mapcar '((B) (pad 2 (hex B)))
         (native "libcrypto.so" "SHA1" '(B . 20) Str (length Str) '(NIL (20))) ) ) )
