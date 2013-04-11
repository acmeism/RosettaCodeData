(de lzwCompress (Lst)
   (let (Codes 255  Dict)
      (balance 'Dict
         (make
            (for C Codes
               (link (cons (char C) C)) ) ) )
      (make
         (let W (pop 'Lst)
            (for C Lst
               (let WC (pack W C)
                  (if (lup Dict WC)
                     (setq W WC)
                     (link (cdr (lup Dict W)))
                     (idx 'Dict (cons WC (inc 'Codes)) T)
                     (setq W C) ) ) )
            (and W (link (cdr (lup Dict W)))) ) ) ) )

(de lzwDecompress (Lst)
   (let (Codes 255  Dict)
      (balance 'Dict
         (make
            (for C Codes
               (link (list C (char C))) ) ) )
      (make
         (let W NIL
            (for N Lst
               (let WC (if (lup Dict N) (cdr @) (cons (last W) W))
                  (chain (reverse WC))
                  (when W
                     (idx 'Dict (cons (inc 'Codes) (cons (last WC) W)) T) )
                  (setq W WC) ) ) ) ) ) )
