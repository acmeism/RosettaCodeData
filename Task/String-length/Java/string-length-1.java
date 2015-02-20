String s = "Hello, world!";
int byteCountUTF16 = s.getBytes("UTF-16").length; // Incorrect: it yields 28 (that is with the BOM)
int byteCountUTF16LE = s.getBytes("UTF-16LE").length; // Correct: it yields 26
int byteCountUTF8  = s.getBytes("UTF-8").length; // yields 13
