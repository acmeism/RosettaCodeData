f = { |n| (1..n).product };

f.(10);

// for numbers larger than 12, use 64 bit float
// instead of 32 bit integers, because the integer range is exceeded
// (1..n) returns an array of floats when n is a float

f.(20.0);
