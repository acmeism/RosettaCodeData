(de write7bitwise (Lst)
   (let (Bits 0  Byte)
      (for N Lst
         (if (=0 Bits)
            (setq Bits 7  Byte (* 2 N))
            (wr (| Byte (>> (dec 'Bits) N)))
            (setq Byte (>> (- Bits 8) N)) ) )
      (unless (=0 Bits)
         (wr Byte) ) ) )

(de read7bitwise ()
   (make
      (let (Bits 0  Byte)
         (while (rd 1)
            (let N @
               (link
                  (if (=0 Bits)
                     (>> (one Bits) N)
                     (| Byte (>> (inc 'Bits) N)) ) )
               (setq Byte (& 127 (>> (- Bits 7) N))) ) )
         (when (= 7 Bits)
            (link Byte) ) ) ) )
