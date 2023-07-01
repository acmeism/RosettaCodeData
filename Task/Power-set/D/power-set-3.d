// Haskell definition:
// foldr f z []     = z
// foldr f z (x:xs) = x `f` foldr f z xs
S foldr(T, S)(S function(T, S) f, S z, T[] rest) {
    return (rest.length == 0) ? z : f(rest[0], foldr(f, z, rest[1..$]));
}

// Haskell definition:
//powerSet = foldr (\x acc -> acc ++ map (x:) acc) [[]]
T[][] powerset(T)(T[] set) {
    import std.algorithm;
    import std.array;
    // Note: The types before x and acc aren't needed, so this could be made even more concise, but I think it helps
    // to make the algorithm slightly clearer.
    return foldr( (T x, T[][] acc) => acc ~ acc.map!(accx => x ~ accx).array , [[]], set );
}
