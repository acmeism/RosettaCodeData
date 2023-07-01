# ncols is the number of columns (i.e. vertical poles)
def column_sums(ncols):
  . as $abacus
  | reduce range(0; ncols) as $col
    ([];
     . + [reduce $abacus[] as $row
           (0; if $row > $col then .+1 else . end)]) ;
