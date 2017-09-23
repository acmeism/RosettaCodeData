# NOTE: This definition of transpose can be omitted
# if your version of jq includes transpose as a builtin.
#
# transpose a possibly jagged matrix, quickly;
# rows are padded with nulls so the result is always rectangular.
def transpose:
  if . == [] then []
  else . as $in
  | (map(length) | max) as $max
  | length as $length
  | reduce range(0; $max) as $j
      ([]; . + [reduce range(0;$length) as $i ([]; . + [ $in[$i][$j] ] )] )
  end;

def x: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
def y: [2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0];

def plot(x;y): "A,B", ( [x,y] | transpose | map( @csv ) | .[]);

plot(x;y)
