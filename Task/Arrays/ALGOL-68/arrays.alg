PROC array_test = VOID:
(
  [1:20]INT a;
  a := others;                           # assign whole array #
  a[1] := -1;                            # assign individual element #
  a[3:5] := (2, 4, -1);                  # assign a slice #
  [1:3]INT slice = a[3:5];               # copy a slice #

  REF []INT rslice = a[3:5];             # create a reference to a slice #
  print((LWB rslice, UPB slice));        # query the bounds of the slice #
  rslice := (2, 4, -1);                  # assign to the slice, modifying original array #

  [1:3, 1:3]INT matrix;                  # create a two dimensional array #
  REF []INT hvector = matrix[2,];        # create a reference to a row #
  REF []INT vvector = matrix[,2];        # create a reference to a column #
  REF [,]INT block = matrix[1:2, 1:2];   # create a reference to an area of the array #

  FLEX []CHAR string := "Hello, world!"; # create an array with variable bounds #
  string := "shorter"                    # flexible arrays automatically resize themselves on assignment #
)
