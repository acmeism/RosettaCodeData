(class +Eatable)

(dm eat> ()
   (prinl "I'm eatable") )


(class +FoodBox)
# obj

(dm set> (Obj)
   (unless (method 'eat> Obj)                # Check if the object is eatable
      (quit "Object is not eatable" Obj) )
   (=: obj Obj) )                            # If so, set the object


(let (Box (new '(+FoodBox))  Eat (new '(+Eatable))  NoEat (new '(+Bla)))
   (set> Box Eat)       # Works
   (set> Box NoEat) )   # Gives an error
