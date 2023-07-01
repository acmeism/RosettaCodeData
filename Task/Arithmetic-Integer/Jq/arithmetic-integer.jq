# Lines which do not have two integers are skipped:

def arithmetic:
  split(" ") | select(length > 0) | map(tonumber)
  | if length > 1 then
    .[0] as $a | .[1] as $b
    | "For a = \($a) and b = \($b):\n" +
      "a + b = \($a + $b)\n" +
      "a - b = \($a - $b)\n" +
      "a * b = \($a * $b)\n" +
      "a/b|floor = \($a / $b | floor)\n" +
      "a % b = \($a % $b)\n" +
      "a | exp = \($a | exp)\n"
    else empty
    end ;

arithmetic
