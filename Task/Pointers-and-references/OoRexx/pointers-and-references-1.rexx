 ::class Foo
 ::method init
   expose x
   x = 0
 ::attribute x

 ::routine somefunction
     a = .Foo~new   -- assigns a to point to a new Foo object
     b = a          -- b and a now point to the same object
     a~x = 5        -- modifies the X variable inside the object pointer to by a
     say b~x        -- displays "5" because b points to the same object as a
