# Each house is a JSON object of the form:
# { "number": _, "nation": _, "owns": _, "color": _, "drinks": _, "smokes": _}

# The list of houses is represented by an array of five such objects.

# Input: an array of objects representing houses.
# Output: [i, solution] where i is the entity unified with obj
# and solution is the updated array
def solve_with_index( obj ):
  . as $Houses
  | range(0; length) as $i
  | ($Houses[$i] | unify(obj)) as $H
  | if $H then $Houses[$i] = $H else empty end
  | [ $i, .] ;

def solve( object ):
  solve_with_index( object )[1];

def adjacent( obj1; obj2 ):
  solve_with_index(obj1) as $H
  | $H[1]
  | (enforce(  $H[0] - 1; unify(obj2) ),
     enforce(  $H[0] + 1; unify(obj2) )) ;

def left_right( obj1; obj2 ):
  solve_with_index(obj1) as $H
  | $H[1]
  | enforce(  $H[0] + 1; unify(obj2) ) ;


# All solutions by generate-and-test
def zebra:
  [range(0;5)] | map({"number": .})                        # Five houses

  | enforce( 0; unify( {"nation": "norwegian"} ) )
  | enforce( 2; unify( {"drinks": "milk"} ) )

  | solve( {"nation": "englishman",  "color": "red"} )
  | solve( {"nation": "swede", "owns": "dog"} )
  | solve( {"nation": "dane", "drinks": "tea"} )

  | left_right( {"color": "green"}; {"color": "white"})

  | solve( {"drinks": "coffee", "color": "green"} )
  | solve( {"smokes": "Pall Mall", "owns": "birds"} )
  | solve( {"color": "yellow", "smokes":  "Dunhill"} )

  | adjacent( {"smokes": "Blend" }; {"owns": "cats"} )
  | adjacent( {"owns": "horse"}; {"smokes": "Dunhill"})

  | solve( {"drinks": "beer", "smokes": "Blue Master"} )
  | solve( {"nation": "german", "smokes": "Prince"})

  | adjacent( {"nation": "norwegian"}; {"color": "blue"})
  | adjacent( {"drinks": "water"}; {"smokes": "Blend"})

  | solve( {"owns": "zebra"} )
;

zebra
