(load "@lib/math.l")

(de prompt (Str . Arg)
   (prin Str " => ")
   (set (car Arg) (in NIL (read))) )

(use (Lat Lng Ref)
   (prompt "Enter latitude      " Lat)
   (prompt "Enter longitude     " Lng)
   (prompt "Enter legal meridian" Ref)
   (prinl)
   (let Slat (sin (*/ Lat pi 180.0))
      (prinl "    sine of latitude:   " (round Slat))
      (prinl "    diff longitude:     " (round (- Lng Ref)))
      (prinl)
      (prinl "Hour, sun hour angle, dial hour line angle from 6am to 6pm")
      (for H (range -6 6)
         (let Hra (- (* 15.0 H) (- Lng Ref))
            (let Hla (*/ (atan (*/ Slat (tan (*/ Hra pi 180.0)) 1.0)) 180.0 pi)
               (prinl
                  "HR="
                  (align 3 H)
                  "; HRA="
                  (align 8 (round Hra))
                  "; HLA="
                  (align 8 (round Hla)) ) ) ) ) ) )
