INT match=0, no match=1, out of memory error=2, other error=3;

STRING slash = "/", pwd=".", parent="..";

PROC walk tree = (STRING path, PROC (STRING)VOID call back)VOID: (
  []STRING files = get directory(path);
  FOR file index TO UPB files DO
    STRING file = files[file index];
    STRING path file = path+slash+file;
    IF file is directory(path file) THEN
      IF file NE pwd AND file NE parent THEN
        walk tree(path file, call back)
      FI
    ELSE
      call back(path file)
    FI
  OD
);

STRING re sort a68 = "[Ss]ort[^/]*[.]a68$";

PROC match sort a68 and print = (STRING path file)VOID:
  IF grep in string(re sort a68, path file, NIL, NIL) = match THEN
    print((path file, new line))
  FI;

walk tree(".", match sort a68 and print)
