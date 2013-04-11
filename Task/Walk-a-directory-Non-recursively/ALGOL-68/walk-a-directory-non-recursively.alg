INT match=0, no match=1, out of memory error=2, other error=3;

[]STRING directory = get directory(".");
FOR file index TO UPB directory DO
  STRING file = directory[file index];
  IF grep in string("[Ss]ort*.[.]a68$", file, NIL, NIL) = match THEN
    print((file, new line))
  FI
OD
