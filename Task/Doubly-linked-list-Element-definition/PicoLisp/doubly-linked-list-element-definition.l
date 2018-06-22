(de 2tail (X DLst)
   (let L (cdr DLst)
      (con DLst (cons X L NIL))
      (if L
         (con (cdr L) (cdr DLst))
         (set DLst (cdr DLst)) ) ) )

(de 2head (X DLst)
   (let L (car DLst)                  # Get current data list
      (set DLst (cons X NIL L))       # Prepend two new cons pairs
      (if L                           # Unless DLst was empty
         (set (cdr L) (car DLst))     # set new 'prev' link
         (con DLst (car DLst)) ) ) )  # otherwise set 'end' link

# We prepend 'not' to the list in the previous example
(2head 'not *DLst)
