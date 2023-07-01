(load "@lib/http.l")

(for (I . X)
   (flip
      (sort
         (make
            (client "rosettacode.org" 80
               "mw/index.php?title=Special:Categories&limit=5000"
               (while (from "<li><a href=\"/wiki/Category:")
                  (let Cat (till "\"")
                     (from "(")
                     (when (format (till " " T))
                        (link (cons @ (ht:Pack Cat))) ) ) ) ) ) ) )
   (prinl (align 3 I) ". " (car X) " - " (cdr X)) )
