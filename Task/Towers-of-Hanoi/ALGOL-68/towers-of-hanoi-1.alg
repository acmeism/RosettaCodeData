PROC move = (INT n, from, to, via) VOID:
  IF n > 0 THEN
    move(n - 1, from, via, to);
    printf(($"Move disk from pole "g" to pole "gl$, from, to));
    move(n - 1, via, to, from)
  FI
;

main: (
  move(4, 1,2,3)
)
