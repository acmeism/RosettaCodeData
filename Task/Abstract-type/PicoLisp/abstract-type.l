# In PicoLisp there is no formal difference between abstract and concrete classes.
# There is just a naming convention where abstract classes start with a
# lower-case character after the '+' (the naming convention for classes).
# This tells the programmer that this class has not enough methods
# defined to survive on its own.

(class +abstractClass)

(dm someMethod> ()
   (foo)
   (bar) )
