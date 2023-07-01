(de a (F)
   (msg 'a)
   F )

(de b (F)
   (msg 'b)
   F )

(mapc
   '((I J)
      (for Op '(and or)
         (println I Op J '-> (Op (a I) (b J))) ) )
   '(NIL NIL T T)
   '(NIL T NIL T) )
