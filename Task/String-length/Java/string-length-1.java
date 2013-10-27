String s = "Hello, world!";
int byteCountUTF16 = s.getBytes("UTF-16").length; // Incorrect it yield 16 that is with the BOM
int byteCountUTF16 = s.getBytes("UTF-16LE").length; // Correct it yield 14
int byteCountUTF8  = s.getBytes("UTF-8").length;
