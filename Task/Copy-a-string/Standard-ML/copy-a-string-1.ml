val src = "Hello";
val srcCopy = CharArray.array (size src, #"x"); (* 'x' is just dummy character *)
CharArray.copyVec {src = src, dst = srcCopy, di = 0};
src = CharArray.vector srcCopy; (* evaluates to true *)
