MODE RSTWOTHREETWO = BITS;
INT ofs = bits width - 9;
INT
   lwb rs232           = ofs + 1,
   carrier detect      = ofs + 1,
   received data       = ofs + 2,
   transmitted data    = ofs + 3,
   data terminal ready = ofs + 4,
   signal ground       = ofs + 5,
   data set ready      = ofs + 6,
   request to send     = ofs + 7,
   clear to send       = ofs + 8,
   ring indicator      = ofs + 9,
   upb rs232           = ofs + 9;

RSTWOTHREETWO rs232 bits := 2r10000000; # up to bits width, OR #
print(("received data: ",received data ELEM rs232bits, new line));

rs232 bits := bits pack((FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE));
print(("received data: ",received data ELEM rs232bits, new line))
