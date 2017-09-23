# Report line and column numbers using conventional numbering (IO=1).
def validate_line(nr):
  def validate_date:
    if is_date then empty else "field 1 in line \(nr) has an invalid date: \(.)" end;
  def validate_length(n):
    if length == n then empty else "line \(nr) has \(length) fields" end;
  def validate_pair(i):
    ( .[2*i + 1] as $n
      | if ($n | is_float) then empty else "field \(2*i + 2) in line \(nr) is not a float: \($n)" end),
    ( .[2*i + 2] as $n
      | if ($n | is_integral) then empty else "field \(2*i + 3) in line \(nr) is not an integer: \($n)" end);

  (.[0] | validate_date),
  (validate_length(49)),
  (range(0; (length-1) / 2) as $i | validate_pair($i)) ;

def validate_lines:
 . as $in
 | range(0; length) as $i | ($in[$i] | validate_line($i + 1));
