# Create an m x n matrix
def matrix(m; n; init):
  if m == 0 then []
  elif m == 1
  then [[range(0;n) | init]]
  elif m > 0
  then [range(0;n) | init] as $row
  | [range(0;m) | $row ]
  else error("matrix\(m);_;_) invalid")
  end;

def lcs($a; $b):
  {lengths: matrix(1+($a|length); 1+($b|length); 0)}
  # row 0 and column 0 are initialized to 0 already
  | reduce range(0; $a|length) as $i (.;
      $a[$i:$i+1] as $x
      | reduce range(0; $b|length) as $j (.;
          $b[$j:$j+1] as $y
          | if $x == $y
            then .lengths[$i+1][$j+1] = .lengths[$i][$j] + 1
            else .lengths[$i+1][$j+1] = ([.lengths[$i+1][$j], .lengths[$i][$j+1]] | max)
            end ))
    # read out the substring from the matrix
    |.result = ""
    | .x = ($a|length)
    | .y = ($b|length)
    | until( .x <= 0 or .y <= 0;
        if .lengths[.x][.y] == .lengths[.x-1][.y]
        then .x -= 1
        elif .lengths[.x][.y] == .lengths[.x][.y-1]
        then .y -= 1
        else
        # debug(".x is \(.x) => \($a[.x-1:.x])")
        .result = $a[.x-1:.x] + .result
        | .x -= 1
        | .y -= 1
        end )
 | .result ;

lcs("1234"; "1224533324"),
lcs("thisisatest"; "testing123testing"),
lcs("thisisatest" * 4; "testing123testing" * 4)
