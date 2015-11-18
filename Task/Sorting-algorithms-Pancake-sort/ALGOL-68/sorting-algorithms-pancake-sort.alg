PROC flip = ([]INT s, INT n) []INT:
   BEGIN
      [UPB s]INT ss := s;
      INT temp;
      FOR i TO n OVER 2 DO
         temp := ss[i];
         ss[i] := ss[n-i+1];
         ss[n-i+1] := temp
      OD;
      ss
   END;

PROC pancake sort = ([]INT s) []INT:
   BEGIN
      INT m;
      [UPB s]INT ss := s;
      FOR i FROM UPB s DOWNTO 2 DO
         m := 1;
         FOR j FROM 2 TO i DO
            IF ss[j] > ss[m] THEN
                m := j
            FI
         OD;

         IF m < i THEN
            IF m > 1 THEN
                ss := flip (ss,m)
            FI;
            ss := flip (ss,i)
         FI
      OD;
    ss
   END;

[10]INT s;
FOR i TO UPB s DO
   s[i] := ENTIER (next random * 100-50)
OD;
printf (($"Pancake sort demonstration"l$));
printf (($"unsorted: "10(g(4) )l$, s));
printf (($"sorted:   "10(g(4) )l$, pancake sort(s)))
