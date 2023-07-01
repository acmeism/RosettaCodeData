main:(
   PROC lcs = (STRING a, b)STRING:
   BEGIN
      IF UPB a = 0 OR UPB b = 0 THEN
         ""
      ELIF a [UPB a] = b [UPB b] THEN
         lcs (a [:UPB a - 1], b [:UPB b - 1]) + a [UPB a]
      ELSE
         STRING x = lcs (a, b [:UPB b - 1]);
         STRING y = lcs (a [:UPB a - 1], b);
         IF UPB x > UPB y THEN x ELSE y FI
      FI
   END # lcs #;
   print((lcs ("thisisatest", "testing123testing"), new line))
)
