package require TclOO

# This is a metaclass, a class that defines the behavior of other classes
oo::class create singleton {
   superclass oo::class
   variable object
   unexport create ;# Doesn't make sense to have named singletons
   method new args {
      if {![info exists object]} {
         set object [next {*}$args]
      }
      return $object
   }
}

singleton create example {
   method counter {} {
      my variable count
      return [incr count]
   }
}
