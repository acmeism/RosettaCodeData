main:(
INT side = 4;
INT right = 1, up = 2, left = 3, down = 4;
[]CHAR direction letters = "ruld";
[]STRING direction descriptions = ("right", "up", "left", "down");

MODE BOARD = REF[,]INT;
MODE CELL = REF INT;

OP = = (BOARD a, BOARD b) BOOL:
  (FOR i TO side DO FOR j TO side DO IF a[i,j] /= b[i,j] THEN mismatch FI OD OD;
  TRUE EXIT
  mismatch: FALSE);

PROC traverse board = (BOARD board, PROC(CELL)VOID callback) VOID:
  FOR i FROM 1 LWB board TO 1 UPB board DO
    FOR j FROM 2 LWB board TO 2 UPB board DO
      callback(board[i,j])
  OD OD;

PROC count blanks = (BOARD board) INT:
  (INT count := 0;
   traverse board(board, (CELL c)VOID: IF c = 0 THEN count +:= 1 FI);
   count);

PROC nth blank = (BOARD board, INT nth) CELL:
  (CELL result;
   INT count := 0;
   traverse board(board, (CELL c)VOID:
                           (IF c = 0 THEN count +:= 1 FI;
                            IF count = nth THEN
                              result := c; return
                            FI));
   return: result);

PROC add new number = (BOARD board) VOID:
  (INT nblanks = count blanks(board);
   INT number   := (random >= .9 | 4 | 2);
   INT position := ENTIER (random * nblanks) + 1;

   nth blank(board, position) := number);

PROC shift = (REF[]INT row, BOOL to the end) VOID:
  (INT from = (to the end | UPB row | LWB row),
       to   = (to the end | LWB row | UPB row),
       dir  = (to the end | -1 | 1);
   FOR i FROM from + dir BY dir TO to  DO
     IF row[i] /= 0 THEN
       INT blank := 0;
       FOR j FROM i - dir BY -dir TO from WHILE row[j] = 0 DO
         blank := j
       OD;
       IF blank /= 0 THEN
         row[blank] := row[i];
         row[i] := 0
       FI
     FI
   OD);

PROC combine = (REF[]INT row, BOOL to the end) VOID:
  (INT from = (to the end | UPB row | LWB row),
       to   = (to the end | LWB row | UPB row),
       dir  = (to the end | -1 | 1);
   FOR i FROM from BY dir TO to - dir DO
     IF row[i] /= 0 AND row[i] = row[i+dir] THEN
       row[i] *:= 2;
       row[i+dir] := 0
     FI
   OD);

PROC move = (BOARD board, INT direction) VOID:
  FOR i TO side DO
    CASE direction IN
      # right # (shift(board[i,], TRUE);  combine(board[i,], TRUE);  shift(board[i,], TRUE)),
      # up    # (shift(board[,i], FALSE); combine(board[,i], FALSE); shift(board[,i], FALSE)),
      # left  # (shift(board[i,], FALSE); combine(board[i,], FALSE); shift(board[i,], FALSE)),
      # down  # (shift(board[,i], TRUE);  combine(board[,i], TRUE);  shift(board[,i], TRUE))
    ESAC
  OD;

PROC print board = (BOARD board)VOID:
  (FOR i FROM 1 LWB board TO 1 UPB board DO
     print("+");
     FOR j FROM 2 LWB board TO 2 UPB board DO print("------+") OD;
     print((new line, "|"));
     FOR j FROM 2 LWB board TO 2 UPB board DO
       print(((board[i,j] = 0 | "     " | whole(board[i,j],-5)), " |"))
     OD;
     print(new line)
   OD;
   print("+"); FOR j FROM 2 LWB board TO 2 UPB board DO print("------+") OD;
   print(new line)
  );

PROC score = (BOARD board) INT:
  (INT result := 0;
   traverse board(board, (CELL c)VOID: result +:= c);
   result);

PROC join = ([]STRING strings, STRING joiner) STRING:
  IF UPB strings > 0 THEN
    STRING result := strings[1];
    FOR i FROM 2 TO UPB strings DO result +:= joiner +:= strings[i] OD;
    result
  ELSE
    ""
  FI;

BOARD board = LOC [side,side]INT;
BOARD previous = LOC [side,side]INT;

traverse board(board, (CELL c)VOID: c := 0);

# start with two numbers #
TO 2 DO add new number(board) OD;

# play! #
STRING prompt := "enter one of [" + direction letters + "] (for " + join(direction descriptions, "/") + "): ";
DO
  CHAR key;
  INT dir;
  print board(board);
  print(("score: ", whole(score(board),0), new line));
  WHILE
    print(prompt);
    read((key, new line));
    NOT char in string(key, dir, direction letters)
  DO SKIP OD;
  previous := board;
  move(board, dir);
  IF count blanks(board) = 0 THEN lose FI;
  traverse board(board, (CELL c)VOID: IF c = 2048 THEN win FI);
  IF previous = board THEN
    print(("try again!", new line))
  ELSE
    add new number(board)
  FI
OD;

win: print board(board); print(("you win!", new line)) EXIT
lose: print(("you lose!", new line))
)
