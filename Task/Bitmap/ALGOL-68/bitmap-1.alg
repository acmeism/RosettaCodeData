# -*- coding: utf-8 -*- #

MODE PIXEL = STRUCT(#SHORT# BITS red,green,blue);
MODE POINT = STRUCT(INT x,y);

MODE IMAGE = [0,0]PIXEL; # instance attributes #

MODE CLASSIMAGE = STRUCT ( # class attributes #
  PIXEL black, red, green, blue, white,
  PROC (REF IMAGE)REF IMAGE init,
  PROC (REF IMAGE, PIXEL)VOID fill,
  PROC (REF IMAGE)VOID print,
# virtual: #
  REF PROC (REF IMAGE, POINT, POINT, PIXEL)VOID line,
  REF PROC (REF IMAGE, POINT, INT, PIXEL)VOID circle,
  REF PROC (REF IMAGE, POINT, POINT, POINT, POINT, PIXEL, UNION(INT, VOID))VOID cubic bezier
);

CLASSIMAGE class image = (
  # black = # (#SHORTEN# 16r00, #SHORTEN# 16r00, #SHORTEN# 16r00),
  # red   = # (#SHORTEN# 16rff, #SHORTEN# 16r00, #SHORTEN# 16r00),
  # green = # (#SHORTEN# 16r00, #SHORTEN# 16rff, #SHORTEN# 16r00),
  # blue  = # (#SHORTEN# 16r00, #SHORTEN# 16r00, #SHORTEN# 16rff),
  # white = # (#SHORTEN# 16rff, #SHORTEN# 16rff, #SHORTEN# 16rff),
  # PROC init = # (REF IMAGE self)REF IMAGE:
    BEGIN
      (fill OF class image)(self, black OF class image);
      self
    END,

  # PROC fill = # (REF IMAGE self, PIXEL color)VOID:
      FOR x FROM 1 LWB self TO 1 UPB self DO
        FOR y FROM 2 LWB self TO 2 UPB self DO
          self[x,y] := color
        OD
      OD,
  # PROC print = # (REF IMAGE self)VOID:
      printf(($n(UPB self)(3(16r2d))l$, self)),
# virtual: #
  # REF PROC line = # LOC PROC (REF IMAGE, POINT, POINT, PIXEL)VOID,
  # REF PROC circle = # LOC PROC (REF IMAGE, POINT, INT, PIXEL)VOID,
  # REF PROC cubic bezier = # LOC PROC (REF IMAGE, POINT, POINT, POINT, POINT, PIXEL, UNION(INT, VOID))VOID
);

OP CLASSOF = (IMAGE image)CLASSIMAGE: class image;
OP INIT = (REF IMAGE image)REF IMAGE: (init OF (CLASSOF image))(image);

SKIP
