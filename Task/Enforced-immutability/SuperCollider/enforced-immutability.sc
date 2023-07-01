// you can freeze any object.
b = [1, 2, 3];
b[1] = 100; // returns [1, 100, 3]
b.freeze; // make b immutable
b[1] = 2; // throws an error ("Attempted write to immutable object.")
