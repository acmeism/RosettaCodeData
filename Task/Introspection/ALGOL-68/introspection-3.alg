#!/usr/local/bin/a68g --script #

OP TYPEOF = (INT skip)STRING: "INT";
OP TYPEOF = (CHAR skip)STRING: "CHAR";
OP TYPEOF = (REAL skip)STRING: "REAL";
OP TYPEOF = (COMPL skip)STRING: "COMPL";

printf(($g" "$,TYPEOF 1, TYPEOF "x", TYPEOF pi, TYPEOF (0 I 1 ), $l$))
