MODE DBL = LONG REAL;
FORMAT dbl = $g(-long real width, long real width-6, -2)$;

MODE XY = STRUCT(DBL x, y);
FORMAT xy root = $f(dbl)" ("b("Exactly", "Approximately")")"$;

MODE DBLOPT = UNION(DBL, VOID);
MODE XYRES = UNION(XY, VOID);

PROC find root = (PROC (DBL)DBL f, DBLOPT in x1, in x2, in x error, in y error)XYRES:(
  INT limit = ENTIER (long real width / log(2)); # worst case of a binary search) #
  DBL x1 := (in x1|(DBL x1):x1|-5.0), # if x1 is EMPTY then -5.0 #
      x2 := (in x2|(DBL x2):x2|+5.0),
      x error := (in x error|(DBL x error):x error|small real),
      y error := (in y error|(DBL y error):y error|small real);
  DBL y1 := f(x1), y2;
  DBL dx := x1 - x2, dy;

  IF y1 = 0 THEN
    XY(x1, y1) # we already have a solution! #
  ELSE
    FOR i WHILE
      y2 := f(x2);
      IF y2 = 0 THEN stop iteration FI;
      IF i = limit THEN value error FI;
      IF y1 = y2 THEN value error FI;
      dy := y1 - y2;
      dx := dx / dy * y2;
      x1 := x2; y1 := y2; # retain for next iteration #
      x2 -:= dx;
  # WHILE # ABS dx > x error AND ABS dy > y error DO
      SKIP
    OD;
    stop iteration:
      XY(x2, y2) EXIT
    value error:
      EMPTY
  FI
);

PROC f = (DBL x)DBL: x UP 3 - LONG 3.1 * x UP 2 + LONG 2.0 * x;

DBL first root, second root, third root;

XYRES first result = find root(f, LENG -1.0, LENG 3.0, EMPTY, EMPTY);
CASE first result IN
  (XY first result): (
    printf(($"1st root found at x = "f(xy root)l$, x OF first result, y OF first result=0));
    first root := x OF first result
  )
  OUT printf($"No first root found"l$); stop
ESAC;

XYRES second result = find root( (DBL x)DBL: f(x) / (x - first root), EMPTY, EMPTY, EMPTY, EMPTY);
CASE second result IN
  (XY second result): (
    printf(($"2nd root found at x = "f(xy root)l$, x OF second result, y OF second result=0));
    second root := x OF second result
  )
  OUT printf($"No second root found"l$); stop
ESAC;

XYRES third result = find root( (DBL x)DBL: f(x) / (x - first root) / ( x - second root ), EMPTY, EMPTY, EMPTY, EMPTY);
CASE third result IN
  (XY third result): (
    printf(($"3rd root found at x = "f(xy root)l$, x OF third result, y OF third result=0));
    third root := x OF third result
  )
  OUT printf($"No third root found"l$); stop
ESAC
