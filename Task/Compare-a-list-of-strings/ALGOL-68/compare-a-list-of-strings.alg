[]STRING list1 = ("AA","BB","CC");
[]STRING list2 = ("AA","AA","AA");
[]STRING list3 = ("AA","CC","BB");
[]STRING list4 = ("AA","ACB","BB","CC");
[]STRING list5 = ("single_element");

[][]STRING all lists to test = (list1, list2, list3, list4, list5);

PROC equal = ([]STRING list) BOOL:
   BEGIN
      BOOL ok := TRUE;
      FOR i TO UPB list - 1 WHILE ok DO
         ok := list[i] = list[i+1]
      OD;
      ok
   END;

PROC less than = ([]STRING list) BOOL:
   BEGIN
      BOOL ok := TRUE;
      FOR i TO UPB list - 1 WHILE ok DO
         ok := list[i] < list[i + 1]
      OD;
      ok
   END;

FOR i TO UPB all lists to test DO
   []STRING list = all lists to test[i];
   print (("list:", (STRING s; FOR i TO UPB list DO s +:= " " + list[i] OD; s), new line));
   IF equal (list) THEN
      print (("...is lexically equal", new line))
   ELSE
      print (("...is not lexically equal", new line))
   FI;
   IF less than (list) THEN
      print (("...is in strict ascending order", new line))
   ELSE
      print (("...is not in strict ascending order", new line))
   FI
OD
