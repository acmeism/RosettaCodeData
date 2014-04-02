# -*- coding: utf-8 -*- #

STRUCT (REAL x, y, heading, BOOL pen down) turtle;

PROC turtle init = VOID: (
  draw erase (window);
  turtle := (0.5, 0.5, 0, TRUE);
  draw move (window, x OF turtle, y OF turtle);
  draw colour name(window, "white")
);

PROC turtle left = (REAL left turn)VOID:
  heading OF turtle +:= left turn;

PROC turtle right = (REAL right turn)VOID:
  heading OF turtle -:= right turn;

PROC turtle forward = (REAL distance)VOID:(
  x OF turtle +:= distance * cos(heading OF turtle) / width * height;
  y OF turtle +:= distance * sin(heading OF turtle);
  IF pen down OF turtle THEN
    draw line
  ELSE
    draw move
  FI (window, x OF turtle, y OF turtle)
);

SKIP
