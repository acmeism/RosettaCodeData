int[] array;
array ~= 5; // append 5
array.length = 3;
array[3] = 17; // runtime error: out of bounds. check removed in release mode.
array = [2, 17, 3];
writefln(array.sort); // 2, 3, 17
