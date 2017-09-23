def euler_solution(df; x1; y1; x2; h):
  def recursion(exp): reduce recurse(exp) as $x (.; $x);
  h as $h
  | [x1, y1]
  | recursion( if ((.[0] < x2 and x1 < x2) or
                   (.[0] > x2 and x1 > x2)) then
  		[ (.[0] + $h), (.[1] + $h*df) ]
             else empty
             end )
  | .[1] ;
