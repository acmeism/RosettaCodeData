int[int] array;
// array ~= 5; // it doesn't work that way!
array[5] = 17;
array[6] = 20;
// prints "[5, 6]" -> "[17, 20]" - although the order is not specified.
writefln(array.keys, " -> ", array.values);
assert(5 in array); // returns a pointer, by the way
if (auto ptr = 6 in array) writefln(*ptr); // 20
