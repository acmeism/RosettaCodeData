# -*- coding: utf-8 -*- #
COMMENT REQUIRES:
  MODE VALUE = ~;
# For example: #
  MODE VALUE = UNION(INT, REAL, COMPL)
END COMMENT

MODE LINKNEW = STRUCT (
  LINK next, prev,
  VALUE value
);

MODE LINK = REF LINKNEW;

SKIP
