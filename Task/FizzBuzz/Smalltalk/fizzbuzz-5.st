fbz := (1 to: 100) asOrderedCollection.
 3 to: 100 by:  3 do: [:i | fbz at: i put: 'Fizz'].
 5 to: 100 by:  5 do: [:i | fbz at: i put: 'Buzz'].
15 to: 100 by: 15 do: [:i | fbz at: i put: 'FizzBuzz'].
fbz do: [:i | Transcript show: i; cr].
