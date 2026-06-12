# $count  should be an integer or `infinite`,
#         where 0 and `infinite` induce the same behavior,
# Output: if $count is greater than 0, then a stream of that many
#         values of the Klarner-Rado sequence is emitted;
#         otherwise [i, value, length] is printed for every i that is a power of 10,
#         where value is the i-th value (counting from 1), and length is the
#         length of the array of pending values.
def klarnerRado($count):

  # insert into a sorted array
  def insert($x):
    if .[-1] < $x then . + [$x]
    else bsearch($x) as $ix
    | if $ix > -1 then . else .[:-1-$ix] + [$x] + .[-1-$ix:] end
    end ;

  ($count | isfinite and . > 0) as $all
  | foreach range(1; if $count == 0 then infinite else $count + 1 end) as $i (
      {array:[1]};

      .i = $i
      | .emit = .array[0]
      | (.emit * 2 + 1) as $two
      | (.emit * 3 + 1) as $three
      | .array |= (.[1:] | insert($two) | insert($three) ) ;

      if $all then .emit
      elif ($i | tostring | test("^10*$"))
      then [.i, .emit, (.array|length)]
      else empty
      end );

([klarnerRado(100)] | _nwise(10) | map(lpad(3)) | join(" ")),
"",

"# [i, value, length]",
limit(7; klarnerRado(infinite))
