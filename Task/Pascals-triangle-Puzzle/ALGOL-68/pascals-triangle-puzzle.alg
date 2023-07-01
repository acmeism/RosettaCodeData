MODE
  FIELD = REAL,
  VEC = [0]REAL,
  MAT = [0,0]REAL;
MODE BRICK = UNION(INT, CHAR);

FLEX[][]BRICK puzzle = (
           ( 151),
         ( " ", " "),
       (  40, " ", " "),
     ( " ", " ", " ", " "),
   ( "x",  11, "y",  4, "z")
);

PROC mat col = (INT row, col)INT: row*(row-1)OVER 2 + col;
INT col x = mat col(5,1),
    col y = mat col(5,3),
    col z = mat col(5,5);

OP INIT = (REF VEC vec)VOID: FOR elem FROM LWB vec TO UPB vec DO vec[elem]:=0 OD;
OP INIT = (REF MAT mat)VOID: FOR row FROM LWB mat TO UPB mat DO INIT mat[row,] OD;

OP / = (MAT a, MAT b)MAT:( # matrix division #
  [LWB b:UPB b]INT p ;
  INT sign;
  [,]FIELD lu = lu decomp(b, p, sign);
  [LWB a:UPB a, 1 LWB a:2 UPB a]FIELD out;
  FOR col FROM 2 LWB a TO 2 UPB a DO out[,col] := lu solve(b, lu, p, a[,col]) OD;
  out
);

OP / = (VEC a, MAT b)VEC: ( # vector division #
  [LWB a:UPB a,1]FIELD transpose a;
  transpose a[,1]:=a;
  (transpose a/b)[,LWB a]
);

INT upb mat = mat col(UPB puzzle, UPB puzzle);
[upb mat, upb mat] REAL mat; INIT mat;
[upb mat] REAL vec; INIT vec;

INT mat row := LWB mat;
INT known row := UPB mat - UPB puzzle + 1;

# build the simultaneous equation to solve #
FOR row FROM LWB puzzle TO UPB puzzle DO
  FOR col FROM LWB puzzle[row] TO UPB puzzle[row] DO
    IF row < UPB puzzle THEN
      mat[mat row, mat col(row, col)] := 1;
      mat[mat row, mat col(row+1, col)] := -1;
      mat[mat row, mat col(row+1, col+1)] := -1;
      mat row +:= 1
    FI;
    CASE puzzle[row][col] IN
      (INT value):(
        mat[known row, mat col(row, col)] := 1;
        vec[known row] := value;
        known row +:= 1
      ),
      (CHAR variable):SKIP
    ESAC
  OD
OD;

# finally add x - y + z = 0 #
mat[known row, col x] := 1;
mat[known row, col y] := -1;
mat[known row, col z] := 1;

FORMAT real repr = $g(-5,2)$;

CO # print details of the simultaneous equation being solved #
FORMAT
  vec repr = $"("n(2 UPB mat-1)(f(real repr)", ")f(real repr)")"$,
  mat repr = $"("n(1 UPB mat-1)(f(vec repr)", "lx)f(vec repr)")"$;

printf(($"Vec: "l$,vec repr, vec, $l$));
printf(($"Mat: "l$,mat repr, mat, $l$));
END CO

# finally actually solve the equation #
VEC solution vec = vec/mat;

# and wrap up by printing the solution #
FLEX[UPB puzzle]FLEX[0]REAL solution;
FOR row FROM LWB puzzle TO UPB puzzle DO
  solution[row] := LOC[row]REAL;
  FOR col FROM LWB puzzle[row] TO UPB puzzle[row] DO
    solution[row][col] := solution vec[mat col(row, col)]
  OD;
  printf(($n(UPB puzzle-row)(4x)$, $x"("f(real repr)")"$, solution[row], $l$))
OD;

FOR var FROM 1 BY 2 TO 5 DO
  printf(($5x$,$g$,puzzle[UPB puzzle][var],"=", real repr, solution[UPB puzzle][var]))
OD
