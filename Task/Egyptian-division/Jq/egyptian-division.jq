def egyptianDivide($dividend; $divisor):
    if ($dividend < 0 or $divisor <= 0) then "egyptianDivide: invalid argument(s)" | error
    elif ($dividend < $divisor) then [0, $dividend]
    else
    { powersOfTwo: [1],
      doublings: [$divisor],
      doubling: (2 * $divisor)
    }
    | until(.doubling > $dividend;
        .powersOfTwo += [.powersOfTwo[-1]*2]
        | .doublings += [.doubling]
        | .doubling *= 2 )
    | .answer = 0
    | .accumulator = 0
    | .i = (.doublings|length)-1
    | until( .i < 0 or .accumulator == $dividend;
        if (.accumulator + .doublings[.i] <= $dividend)
        then .accumulator += .doublings[.i]
        | .answer += .powersOfTwo[.i]
        else .
	    end
        | .i += -1)
    | [.answer, $dividend - .accumulator]
    end;

def task($dividend; $divisor):
  egyptianDivide($dividend; $divisor)
  | "\($dividend) ÷ \($divisor) = \(.[0]) with remainder \(.[1]).";

task(580; 34)
