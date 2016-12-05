(load "sha256.l")

(setq *Alphabet
   (chop "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz") )
(de unbase58 (Str)
   (let (Str (chop Str)  Lst (need 25 0)  C)
      (while (setq C (dec (index (pop 'Str) *Alphabet)))
         (for (L Lst L)
            (set
               L (& (inc 'C (* 58 (car L))) 255)
               'C (/ C 256) )
            (pop 'L) ) )
      (flip Lst) ) )
(de valid (Str)
   (and
      (setq @@ (unbase58 Str))
      (=
         (head 4 (sha256 (sha256 (head 21 @@))))
         (tail 4 @@) ) ) )
(test
   T
   (valid "17NdbrSGoUotzeGCcMMCqnFkEvLymoou9j") )
(test
   T
   (=
      NIL
      (valid "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62j")
      (valid "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62!")
      (valid "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62iz")
      (valid "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62izz") ) )
