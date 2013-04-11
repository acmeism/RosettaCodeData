val srcCopy2 = CharArray.array (CharArray.length srcCopy, #"x"); (* 'x' is just dummy character *)
CharArray.copy {src = srcCopy, dst = srcCopy2, di = 0};
