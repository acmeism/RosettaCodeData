def Outer:
   def IncrementField: .field += 1;

   {field: 123}
   | def Inner1:
       {super: .,
        field: 456}
       | IncrementField
       | probe("Inner1's field is \(.field) and can see the super value is \(.super.field)")
       | .super ;  # avoid contamination

     def Inner2:
       IncrementField
       | probe("Inner2 has altered the value of .field which is now \(.field)");

   probe("Outer field's value is initially \(.field)")
   | Inner1
   | .field = 0
   | probe("Outer field's value has been changed to \(.field)")
   | Inner1
   | probe("Calling Inner2")
   | Inner2
;

Outer
