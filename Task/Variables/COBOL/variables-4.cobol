*> Group data items do not have a picture clause.
01  group-item. *> The 'implied' PIC for group-item is PIC X(20).
    03  sub-data          PIC X(10).
    03  more-sub-data     PIC X(10).

*> Example use of FILLER.
01  formatted-data.
    03  part-one          PIC X(10).
    03  FILLER            PIC X.
    03  part-two          PIC X(10).
