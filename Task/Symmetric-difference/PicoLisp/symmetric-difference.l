(de symdiff (A B)
   (uniq (conc (diff A B) (diff B A))) )
