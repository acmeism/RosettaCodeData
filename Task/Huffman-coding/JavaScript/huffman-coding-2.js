var s = "this is an example for huffman encoding";
print(s);

var huff = new HuffmanEncoding(s);
huff.inspect_encoding();

var e = huff.encoded_string;
print(e);

var t = huff.decode(e);
print(t);

print("is decoded string same as original? " + (s==t));
