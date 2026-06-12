# input: width
# $start: maximum first digit allowed e.g. 9 for unrestricted
# output: the specified stream of strange numbers
def generate($start):
  # The next permissible digit
  def nxt: . as $i | range(0;10) | select($i - . | length | IN(2, 3, 5, 7));

  # input: width
  # $first: first digit
  # output: an array of $n digits
  def gen($first):
    . as $n
    | if $n == 0 then []
      elif $n == 1 then [$first]
      else ($n - 1) | gen($first) | . + ((.[-1]|nxt) | [.])
      end;

   gen( range(1; $start+1) );

[3 | generate(4) | map(tostring) | join("") | tonumber]
| nwise(10) | map(lpad(3)) | join(" ")
