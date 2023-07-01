(setq *Table
   (mapcar
      '((N)
         (do 8
            (setq N
               (if (bit? 1 N)
                  (x| (>> 1 N) `(hex "EDB88320"))
                  (>> 1 N) ) ) ) )
      (range 0 255) ) )

(de crc32 (Lst)
   (let Crc `(hex "FFFFFFFF")
      (for I (chop Lst)
         (setq Crc
            (x|
               (get
                  *Table
                  (inc (x| (& Crc 255) (char I))) )
               (>> 8 Crc) ) ) )
      (x| `(hex "FFFFFFFF") Crc) ) )

(let Str "The quick brown fox jumps over the lazy dog"
   (println (hex (crc32 Str)))
   (println
      (hex (native "libz.so" "crc32" 'N 0 Str (length Str))) ) )

(bye)
