# type 'a tree = Leaf of 'a | Node of 'a tree list ;;
type 'a tree = Leaf of 'a | Node of 'a tree list

# let rec flatten = function
     Leaf x -> [x]
   | Node xs -> List.concat (List.map flatten xs) ;;
val flatten : 'a tree -> 'a list = <fun>

# flatten (Node [Node [Leaf 1]; Leaf 2; Node [Node [Leaf 3; Leaf 4]; Leaf 5]; Node [Node [Node []]]; Node [Node [Node [Leaf 6]]]; Leaf 7; Leaf 8; Node []]) ;;
- : int list = [1; 2; 3; 4; 5; 6; 7; 8]
