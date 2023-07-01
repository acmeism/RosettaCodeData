val testString="{\"firstName\":\"John\",\"lastName\":\"Smith\",\"age\":25,\"address\":{\"streetAddress\":\"21 2nd Street\",\"city\":\"New York\",\"state\":\"NY\",\"postalCode\":\"10021\"},\"phoneNumber\":[{\"type\":\"home\",\"numbers\":[{\"o\":\"212 555-1234\",\"h\":\"119 323-1234\"}]},{\"type\":\"fax\",\"number\":\"646 555-4567\"}]}" ;

testString =  (writeJS o storeJsString) testString ;
val it = true : bool                                             (*  because the test string was unformatted *)

val toMlVal = fn input =>
 case String.isPrefix "\"" input
 of true => St (String.substring (input,1,(String.size input)-2) )
    |  _ => case IntInf.fromString input of
                SOME n => It n
              | NONE   => case Real.fromString input of
		       SOME x => Rl x
                     | NONE   => case Bool.fromString input of
		           SOME b => Bl b
                         | NONE   => St "" ;

val toMlVal = fn: string -> jvals

List.nth (gothruAndDo toMlVal (storeJsString testString  ) ,3);

val it =
    elem
    (St "address",
     block
      [elem (St "streetAddress", value (St "21 2nd Street")),
       elem (St "city", value (St "New York")),
       elem (St "state", value (St "NY")),
       elem (St "postalCode", value (St "10021"))]):
   (jvals, jvals content) element
