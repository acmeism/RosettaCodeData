### Generic functions
def power($a;$b): reduce range(0;$b) as $i (1; . * $a);

# Emit the reverse of the string $s
def reverse($s):
  $s | tostring | split("") | reverse | join("");

def skip($n; stream):
  foreach stream as $s (-1;
      if . == $n then . else .+1 end;
      select(. == $n) | $s);

### Palindromic gapful numbers

# Output: a stream of non-trivial palindromic gapful numbers ending in the specified digit
def palindromicgapfuls($digit):
  {emit: null,
   dd: (11 * $digit),                             # digit gapful divisor: 11, 22,...88, 99
   power: 1}
  | foreach range(0; infinite) as $_ (.;
      .power += 1
      | (power(10; .power / 2 | floor)) as $base  # value of middle digit position: 10..
      | ($base * 11) as $base11                   # value of middle two digits positions: 110..
      | ($base * $digit) as $this_lo              # starting half for this digit: 10.. to  90..
      | ($base * ($digit + 1)) as $next_lo        # starting half for next digit: 20.. to 100..

      | foreach range($this_lo; $next_lo; 10) as $front_half (.;  # d_00; d_10; d_20; ...
          ($front_half|tostring) as $left_half
          | reverse($left_half) as $right_half
          | if .power%2 == 1
            then .palindrome = (($left_half + $right_half) | tonumber)
            | foreach range(0;10) as $i (.;
                .emit = if .palindrome % .dd == 0
                        then .palindrome
                        else null
                        end
                | .palindrome += $base11 )
            else .palindrome = ((($left_half[:-1]) + $right_half) | tonumber)
            | foreach range(0;10) as $i (.;
                .emit = if .palindrome % .dd == 0
                        then .palindrome
                        else null
                        end
                | .palindrome += $base )
            end ) )
  | select(.emit).emit ;

def palindromicgapfuls($count; $keep):
  range(1; 10) as $digit
  | "\($digit) : \([limit($keep; skip($count - $keep; palindromicgapfuls($digit)))])" ;

def task:
  "First 20 non-trivial palindromic gapful numbers ending with:",
   palindromicgapfuls(20; 20),

  "\nLast 15 of first 100 non-trivial palindromic gapful numbers ending in:",
   palindromicgapfuls(100; 15),

  "\nLast 10 of first 1000 non-trivial palindromic gapful numbers ending in:",
   palindromicgapfuls(1000; 10),

  "\n100,000th non-trivial palindromic gapful number ending with:",
   palindromicgapfuls(100000; 1),

  "\n1,000,000th non-trivial palindromic gapful number ending with:",
   palindromicgapfuls(1000000; 1);

task
