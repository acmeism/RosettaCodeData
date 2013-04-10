STRING nl = REPR 10;
STRING text in list := "Given$a$text$file$of$many$lines,$where$fields$within$a$line$"+nl+
  "are$delineated$by$a$single$'dollar'$character,$write$a$program"+nl+
  "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$"+nl+
  "column$are$separated$by$at$least$one$space."+nl+
  "Further,$allow$for$each$word$in$a$column$to$be$either$left$"+nl+
  "justified,$right$justified,$or$center$justified$within$its$column.";

MODE PAGE = FLEX[0,0]STRING;
PAGE page;

PROC flex page = (PAGE in page, INT row, col)PAGE:(
  HEAP FLEX[row, col]STRING out page;
  out page[:1 UPB in page, :2 UPB in page] := in page;
  FOR r TO row DO
    FOR c FROM 2 UPB in page + 1 TO col DO out page[r,c]:="" OD
  OD;
  FOR r FROM 1 UPB in page + 1 TO row DO
    FOR c FROM 1 TO col DO out page[r,c]:="" OD
  OD;
  out page
);

FILE text in file;
associate(text in file, text in list);
make term(text in file, "$");

on physical file end(text in file, (REF FILE skip)BOOL: stop iteration);
on logical file end(text in file, (REF FILE skip)BOOL: stop iteration);
FOR row DO
  on line end(text in file, (REF FILE skip)BOOL: stop iteration);
  FOR col DO
    STRING tok;
    getf(text in file, ($gx$,tok));
    IF row > 1 UPB page THEN page := flex page(page, row, 2 UPB page) FI;
    IF col > 2 UPB page THEN page := flex page(page, 1 UPB page, col) FI;
    page[row,col]:=tok
  OD;
  stop iteration:
    SKIP
OD;
stop iteration:
  SKIP;

BEGIN
  PROC aligner = (PAGE in page, PROC (STRING,INT)STRING aligner)VOID:(
    PAGE page := in page;
    [2 UPB page]INT max width;
    FOR col TO 2 UPB page DO
      INT max len:=0; FOR row TO UPB page DO IF UPB page[row,col]>max len THEN max len:=UPB page[row,col] FI OD;
      FOR row TO UPB page DO page[row,col] := aligner(page[row,col], maxlen) OD
    OD;
    printf(($n(UPB page)(n(2 UPB page -1)(gx)gl)$,page))
  );

  PROC left = (STRING in, INT len)STRING: in + " "*(len - UPB in),
       right = (STRING in, INT len)STRING: " "*(len - UPB in) + in,
       centre = (STRING in, INT len)STRING: ( INT pad=len-UPB in;  pad%2*" "+ in + (pad-pad%2)*" " );

  []STRUCT(STRING name, PROC(STRING,INT)STRING align) aligners = (("Left",left), ("Left",right), ("Centre",centre));

  FOR index TO UPB aligners DO
    print((new line, "# ",name OF aligners[index]," Column-aligned output:",new line));
    aligner(page, align OF aligners[index])
  OD
END
