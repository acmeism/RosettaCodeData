// Return the number of bytes depending on the encoding,
// here explicitly UTF-8
unsigned numberOfBytes =
   [@"møøse" lengthOfBytesUsingEncoding: NSUTF8StringEncoding]; // 7
