def isPalindrome2:
    if (. % 2 == 0) then . == 0
    else {x:0, n: .}
    | until(.x >= .n;
        .x = .x*2 + (.n % 2)
        | .n |= idivide(2) )
    | .n == .x or .n == (.x|idivide(2))
    end;

def reverse3:
  {n: ., x: 0}
  | until (.n == 0;
      .x = .x*3 + (.n % 3)
      | .n |= idivide(3) )
  | .x;

def show:
  "Decimal : \(.)",
  "Binary  : \(convert(2))",
  "Ternary : \(convert(3))",
  "";

def task($count):
  "The first \($count) numbers which are palindromic in both binary and ternary are:",
  (0|show),
  ({cnt:1,  lo:0, hi:1, pow2:1, pow3:1}
   | iterate( .cnt < $count;
       .emit = null
       | .i = .lo
       | until (.i >= .hi or .emit;
           ((.i*3+1)*.pow3 + (.i|reverse3)) as $n
           | if $n|isPalindrome2
             then .emit = [$n|show]
             | .cnt += 1
             else .
             end
           | .i += 1 )
       | if .cnt == $count then . # all done
         else if .i == .pow3
              then .pow3 *= 3
              else .pow2 *= 4
              end
         | .break = false
         | until( .break;
             until(.pow2 > .pow3; .pow2 *= 4)
             | .lo2 = idivide( idivide(.pow2;.pow3) - 1; 3)
             | .hi2 = (idivide(idivide(.pow2*2;.pow3)-1;3) + 1)
             | .lo3 = (.pow3|idivide(3))
             | .hi3 = .pow3
             | if   .lo2 >= .hi3 then .pow3 *= 3
               elif .lo3 >= .hi2 then .pow2 *= 4
               else .lo = ([.lo2, .lo3]|max)
               | .hi = ([.hi2, .hi3]|min)
               | .break = true
               end )
	 end)
     | select(.emit).emit[] );

task(6)
