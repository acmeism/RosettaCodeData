# iterates through all possible dice #
PROC iterate = (PROC(INT, []INT)VOID f)VOID:
  BEGIN
    INT n := 1;
    [4]INT sides;
    FOR i FROM 1 TO 4 DO FOR j FROM i TO 4 DO
    FOR k FROM j TO 4 DO FOR l FROM k TO 4 DO
      sides := (i, j, k, l);
      f(n, sides);
      n +:= 1
    OD OD OD OD
  END;

# compares 2 dice, returns (-1, 0, 1) for a (<, =, >) b #
PROC compare = ([]INT a, []INT b)INT:
  BEGIN
    INT result := 0;
    FOR i TO UPB a DO
      FOR j TO UPB b DO
        result +:= SIGN(a[i] - b[j])
      OD
    OD;
    SIGN result
  END;

# compact representation of die #
PROC str = ([]INT die)STRING:
  BEGIN
    STRING result := " " * UPB die;
    FOR i TO UPB die DO
      result[i] := REPR (die[i] + ABS "0")
    OD;
    result
  END;

# first count all possible dice #
INT ndice := 0;
iterate((INT n, []INT sides)VOID: ndice +:= 1);

# store them by index #
[ndice][4]INT dice;
iterate((INT n, []INT sides)VOID: dice[n] := sides);

# fill the results of an all-play-all tournament #
[ndice,ndice]INT results;
FOR i TO ndice DO
  FOR j FROM i TO ndice DO
    results[i,j] := compare(dice[i], dice[j]);
    results[j,i] := results[i,j] * -1
  OD
OD;

# helper function to print the intransitive sequence #
PROC print seq = ([]INT idxs)VOID:
  BEGIN
    FOR i TO UPB idxs DO
      IF i > 1 THEN print((" < ")) FI;
      print((str(dice[idxs[i]])))
    OD;
    print((newline))
  END;

# find all (s,t,u) where s < t < u < s #
print(("3 dice:", newline));
FOR s TO ndice DO
  FOR t TO ndice DO
    IF results[s,t] = -1 THEN
      FOR u TO ndice DO
        IF results[t,u] = -1 AND results[u,s] = -1 THEN
          print seq((s, t, u, s))
        FI
      OD
    FI
  OD
OD;

# find all (s,t,u,v) where s < t < u < v < s #
print(("4 dice:", newline));
FOR s TO ndice DO
  FOR t TO ndice DO
    IF results[s,t] = -1 THEN
      FOR u TO ndice DO
        IF results[t,u] = -1 THEN
          FOR v TO ndice DO
            IF results[u,v] = -1 AND results[v,s] = -1 THEN
              print seq((s, t, u, v, s))
            FI
          OD
        FI
      OD
    FI
  OD
OD
