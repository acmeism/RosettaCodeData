multi erat(Int $N) { erat 2 .. $N }
multi erat(@a where @a[0] > sqrt @a[*-1]) { @a }
multi erat(@a) { @a[0], erat(@a.grep: * % @a[0]) }
 
say erat 100;
