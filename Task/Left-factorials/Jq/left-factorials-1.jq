def left_factorial:
  reduce range(1; .+1) as $i
  # state: [i!, !i]
    ([1,0]; .[1] += .[0] | .[0] *= $i)
  | .[1];

# input and gap should be integers
def left_factorial_lengths(gap):
  reduce range(1; .+1) as $i
  # state: [i!, !i, gap]
    ([1, 0, []];
    .[1] = (.[0] + .[1])
    | .[0] = (.[0] * $i)
    | (.[1] | tostring | length) as $lf
    | if $i % gap == 0 then .[2] += [[$i, $lf]] else . end)
  | .[2];

((range(0;11), (range(2; 12) * 10)) |  "\(.): \(left_factorial)"),

(10000 | left_factorial_lengths(1000) | .[] | "\(.[0]): length is \(.[1])")
