MODE DATA = INT;

PRIO C = 7;

# Calculate the number of combinations anticipated #
OP C = (INT n, k)INT:
  CASE k + 1 IN
  # case 0: # 1,
  # case 1: # n
    OUT (n - 1) C (k - 1) * n OVER k
  ESAC;

PROC combinations = (INT m, []DATA list)[,]DATA: (
  CASE m IN
  # case 1: # ( # transpose list #
    [UPB list,1]DATA out;
    out[,1]:=list;
    out
  )
  OUT
    [UPB list C m, m]DATA out;
    INT index out := 1;
    FOR i TO UPB list DO
      DATA x = list[i];
      [,]DATA y = combinations(m - 1, list[i+1:]);
      FOR suffix TO UPB y DO
        out[index out,1 ] := x;
        out[index out,2:] := y[suffix,];
        index out +:= 1
      OD
    OD;
    out
  ESAC
);

PRIO COMB = 7;
OP COMB = (INT n, k)[,]INT: (
  [k]DATA list; # create a list to recombine #
  FOR i TO UPB list DO list[i]:=i OD;
  combinations(n,list)
);

INT m = 3;

#IF formatted transput possible THEN#
  FORMAT data repr = $d$;
  FORMAT list repr = $"("n(m-1)(f(data repr)",")f(data repr)")"$;
  printf ((list repr, 3 COMB 5, $l$));
#ELSE#
  [,]DATA result = 3 COMB 5;
  FOR row TO UPB result DO
    print ((result[row,], new line))
  OD
#FI#
