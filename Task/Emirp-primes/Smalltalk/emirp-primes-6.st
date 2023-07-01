Object subclass: #Cons
    instancevariableNames:'car cdr'.

car:newCar cdr:newCdr
    car := newCar. cdr := newCdr

car
    ^car

cdr
    ^cdr

Cons subclass:#LazyCons

cdr
    cdr := cdr value.
    self changeClassTo:Cons.
    ^cdr
