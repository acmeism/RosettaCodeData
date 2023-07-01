(de fasta (F)
   (in F
      (while (from ">")
         (prin (line T) ": ")
         (until (or (= ">" (peek)) (eof))
            (prin (line T)) )
         (prinl) ) ) )
(fasta "fasta.dat")
