BITS bits := bits pack((TRUE, TRUE, FALSE, FALSE)); # packed array of BOOL #
BYTES bytes := bytes pack("Hello, world"); # packed array of CHAR #
print((
  "BITS and BYTES are fixed width:", new line,
  "bits width:", bits width, ", max bits: ", max bits, ", bits:", bits, new line,
  "bytes width: ",bytes width, ", UPB:",UPB STRING(bytes), ", string:", STRING(bytes),"!", new line
))
