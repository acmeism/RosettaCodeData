INT max_elements = 1000000;

# Return the k-th smallest item in array x of length len #
PROC quick_select = (INT k, REF[]REAL x) REAL:
   BEGIN

      PROC swap = (INT a, b) VOID:
         BEGIN
	    REAL t = x[a];
	    x[a] := x[b]; x[b] := t
         END;

      INT left := 1, right := UPB x;
      INT pos, i;
      REAL pivot;

      WHILE left < right DO
	 pivot := x[k];
	 swap (k, right);
	 pos := left;
	 FOR i FROM left TO right DO
	    IF x[i] < pivot THEN
	       swap (i, pos);
	       pos +:= 1
	    FI
	 OD;
	 swap (right, pos);
	 IF pos = k THEN break FI;
	 IF pos < k THEN left := pos + 1
	 ELSE right := pos - 1
         FI
      OD;
break:
      SKIP;
      x[k]
   END;

 # Initialize random length REAL array with random doubles #
 INT length = ENTIER (next random * max_elements);
 [length]REAL x;
 FOR i TO length DO
    x[i] := (next random * 1e6 - 0.5e6)
 OD;

 REAL median :=
    IF NOT ODD length THEN
       # Even number of elements, median is average of middle two #
       (quick_select (length % 2, x) + quick_select(length % 2 - 1, x)) / 2
    ELSE
       # select middle element #
       quick_select(length % 2, x)
    FI;

 # Sanity testing of median #
 INT less := 0, more := 0, eq := 0;
 FOR i TO length DO
    IF x[i] < median THEN less +:= 1
    ELIF x[i] > median THEN more +:= 1
    ELSE eq +:= 1
    FI
 OD;
 print (("length: ", whole (length,0), new line, "median: ", median, new line,
	 "<: ", whole (less,0), new line,
	 ">: ", whole (more, 0), new line,
	 "=: ", whole (eq, 0), new line))
