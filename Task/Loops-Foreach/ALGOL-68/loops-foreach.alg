[]UNION(STRING, INT, PROC(REF FILE)VOID) collection = ("Mary","Had",1,"little","lamb.",new line);

FOR index FROM LWB collection TO UPB collection DO
  print((collection[index]," "))
OD
