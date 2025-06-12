let rec fix f = f <| fun() -> fix f
// val fix : f:((unit -> 'a) -> 'a) -> 'a

// the application of this true Y-combinator is the same as for the above non function recursive version.
