main: (
  STRING s = "abcdefgh";
  INT n = 2, m = 3;
  CHAR char = "d";
  STRING chars = "cd";

  printf(($gl$, s[n:n+m-1]));
  printf(($gl$, s[n:]));
  printf(($gl$, s[:UPB s-1]));

  INT pos;
  char in string("d", pos, s);
  printf(($gl$, s[pos:pos+m-1]));
  string in string("de", pos, s);
  printf(($gl$, s[pos:pos+m-1]))
)
