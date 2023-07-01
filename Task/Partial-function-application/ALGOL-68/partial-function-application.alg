MODE SET = FLEX[0]INT;

MODE F = PROC(INT)INT,
     FS = PROC(SET)SET;

PROC fs = (F f, SET set)SET: (
  [LWB set:UPB set]INT out;
  FOR i FROM LWB set TO UPB set DO out[i]:=f(set[i]) OD;
  out
);

PROC f1 = (INT value)INT: value * 2,
     f2 = (INT value)INT: value ** 2;

FS fsf1 = fs(f1,),
   fsf2 = fs(f2,);

[4]INT set;
FORMAT set fmt = $"("n(UPB set-LWB set)(g(0)", ")g(0)")"l$;

set := (0, 1, 2, 3);
  printf((set fmt, fsf1((0, 1, 2, 3)))); # prints (0, 2, 4, 6) #
  printf((set fmt, fsf2((0, 1, 2, 3)))); # prints (0, 1, 4, 9) #

set := (2, 4, 6, 8);
  printf((set fmt, fsf1((2, 4, 6, 8)))); # prints (4, 8, 12, 16) #
  printf((set fmt, fsf2((2, 4, 6, 8))))  # prints (4, 16, 36, 64) #
