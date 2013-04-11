PROC scaffolding = VOID:
BEGIN
   INT level := 0;

   PROC step = BOOL:
   BEGIN
      IF random > 0.5 THEN
         level +:= 1;
         print(("Climbed up to",level, new line));
         TRUE
      ELSE
         level -:= 1;
         print(("Fell down to",level, new line));
         FALSE
      FI
   END # step #;

   PROC step up = VOID:
   BEGIN
      WHILE NOT step DO
         step up
      OD
   END # step up #;

   step up
END # scaffolding #;

scaffolding
