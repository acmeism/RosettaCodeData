BEGIN
  INT level = 4;    # <-- change this #

  INT side = 2**level * 2 - 2;
  [-side:1, 0:side]STRING grid;
  INT x := 0, y := 0, dir := 0;
  INT old dir := -1;
  INT e=0, n=1, w=2, s=3;

  FOR i FROM 1 LWB grid TO 1 UPB grid DO
    FOR j FROM 2 LWB grid TO 2 UPB grid DO grid[i,j] := "  "
  OD OD;

  PROC left  = VOID: dir := (dir + 1) MOD 4;
  PROC right = VOID: dir := (dir - 1) MOD 4;
  PROC move  = VOID: (
    CASE dir + 1 IN
      # e: # x +:= 1, # n: # y -:= 1, # w: # x -:= 1, # s: # y +:= 1
    ESAC
  );
  PROC forward = VOID: (
    # draw corner #
    grid[y, x] := CASE old dir + 1 IN
                   # e # CASE dir + 1 IN "──", "─╯", " ?", "─╮" ESAC,
                   # n # CASE dir + 1 IN " ╭", " │", "─╮", " ?" ESAC,
                   # w # CASE dir + 1 IN " ?", " ╰", "──", " ╭" ESAC,
                   # s # CASE dir + 1 IN " ╰", " ?", "─╯", " │" ESAC
                  OUT "  "
                  ESAC;
    move;
    # draw segment #
    grid[y, x] := IF dir = n OR dir = s THEN " │" ELSE "──" FI;
    # advance to next corner #
    move;
    old dir := dir
  );

  PROC a = (INT level)VOID:
    IF level > 0 THEN
      left; b(level-1); forward; right; a(level-1); forward;
      a(level-1); right; forward; b(level-1); left
    FI,
      b = (INT level)VOID:
    IF level > 0 THEN
      right; a(level-1); forward; left; b(level-1); forward;
      b(level-1); left; forward; a(level-1); right
    FI;

  # draw #
  a(level);

  # print #
  FOR row FROM 1 LWB grid TO 1 UPB grid DO
    print((grid[row,], new line))
  OD
END
