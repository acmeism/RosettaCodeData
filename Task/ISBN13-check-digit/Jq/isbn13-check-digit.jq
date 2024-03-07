def isbn_check:
  def digits: tostring | explode | map( select(. >= 48 and . <= 57) | [.] | implode | tonumber);
  def sum(s): reduce s as $x (null; . + $x);
  digits
  | . as $digits
  |      sum(range(0;length;2) | $digits[.]) as $one
  | (3 * sum(range(1;length;2) | $digits[.])) as $two
  | (($one+$two) % 10) == 0;

def testingcodes:
 ["978-0596528126", "978-0596528120",
  "978-1788399081", "978-1788399083"];

testingcodes[]
| "\(.): \(if isbn_check then "good" else "bad" end)"
