#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

PR read "prelude/turtle_draw.a68" PR;
MODE EXCEPTOBJ = FILE;
OP FIRMSTR = (EXCEPTOBJ obj)STRING: "FILE";

PR read "prelude/exception.a68" PR;

REAL sqrt 2 = sqrt(2), degrees = pi/180;

STRUCT ( INT count, depth, current shade, upb lines, upb colours ) morph;

PROC morph init = (INT depth)VOID: (
  count OF morph := 0;
  depth OF morph := depth;
  current shade OF morph := -1;
  upb lines OF morph := 2**depth;
  upb colours OF morph := 16
);

PROC morph colour = VOID: (
  INT colour sectors = 3; # RGB #
  INT candidate shade = ENTIER ( count OF morph / upb lines OF morph * upb colours OF morph );
  IF candidate shade /= current shade OF morph THEN
    current shade OF morph := candidate shade;
    REAL colour sector = colour sectors * candidate shade / upb colours OF morph - 0.5;
    REAL shade = colour sector - ENTIER colour sector;
    CASE ENTIER colour sector + 1 # of 3 # IN
      draw colour (window, 1 - shade, shade, 0),
      draw colour (window, 0, 1 - shade, shade)
    OUT
      draw colour (window, shade, 0, 1 - shade)
    ESAC
  FI;
  count OF morph +:= 1
);

PROC dragon init = VOID: (
  pen down OF turtle := FALSE;
    turtle forward(23/64); turtle right(90*degrees);
    turtle forward (1/8);  turtle right(90*degrees);
  pen down OF turtle := TRUE
);

PROC dragon = (REAL in step, in length, PROC(REAL)VOID zig, zag)VOID: (
  IF in step <= 0 THEN
    morph colour;
    turtle forward(in length)
  ELSE
    REAL step = in step - 1;
    REAL length = in length / sqrt 2;

    zig(45*degrees);
    dragon(step, length, turtle right, turtle left);
    zag(90*degrees);
    dragon(step, length, turtle left, turtle right);
    zig(45*degrees)
  FI
);

PROC window init = VOID: (
  STRING aspect; FILE f; associate(f, aspect); putf(f, ($g(-4)"x"g(-3)$, width, height));
CO # depricated #
  IF NOT draw device (window, "X", aspect)THEN
    raise undefined(window, "cannot initialise X draw device") FI;
END CO
  IF open (window, "Dragon Curve", stand draw channel) = 0 THEN
    raise undefined(window, "cannot open Dragon Curve window") FI;
  IF NOT make device (window, "X", aspect) THEN
    raise undefined(window, "cannot make device X draw device") FI
);

INT width = 800-15, height = 600-15;

FILE window; window init;
  INT cycle length = 18;
  FOR snap shot TO cycle length DO
    INT depth := (snap shot - 2) MOD cycle length;
    turtle init; dragon init; morph init(depth);
# move to initial turtle location #
    dragon(depth, 7/8, turtle right, turtle left);
    draw show (window);
    VOID(system("sleep 1"))
  OD;
close (window)
