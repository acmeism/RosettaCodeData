OP + = (STRING s)STRING:
BEGIN
   CHAR item = s[LWB s];
   STRING out;
   FOR index FROM LWB s + 1 TO UPB s DO
      IF item /= s [index] THEN
         out := whole(index - LWB s, 0) + item + (+(s [index:UPB s]));
         GO TO return out
      FI
   OD;
   out := whole (UPB s, 0) + item;
   return out: out
END  # + #;

OP + = (CHAR s)STRING:
  + STRING(s);

print ((+"1", new line));
print ((+(+"1"), new line));
print ((+(+(+"1")), new line));
print ((+(+(+(+"1"))), new line));
print ((+(+(+(+(+"1")))), new line));
print ((+(+(+(+(+(+"1"))))), new line));
print ((+(+(+(+(+(+(+"1")))))), new line));
print ((+(+(+(+(+(+(+(+"1"))))))), new line));
print ((+(+(+(+(+(+(+(+(+"1")))))))), new line));
print ((+(+(+(+(+(+(+(+(+(+"1"))))))))), new line))
