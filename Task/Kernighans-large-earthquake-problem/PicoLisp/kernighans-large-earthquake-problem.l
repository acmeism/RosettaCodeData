(load "@lib/misc.l")

(in "kernighan.txt"
   (until (eof)
      (let (Date (read)  Quake (read)  Mag (read))
     (when (> Mag 6)
        (prinl (align -10 Date) " " (align -15 Quake) " " Mag)))))
(bye)
