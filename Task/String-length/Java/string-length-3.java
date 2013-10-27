String str = "\uD834\uDD2A"; //U+1D12A
int not_really__the_length = str.length(); // value is 2, which is not the length in characters
int actual_length = str.codePointCount(0, str.length()); // value is 1, which is the length in characters
