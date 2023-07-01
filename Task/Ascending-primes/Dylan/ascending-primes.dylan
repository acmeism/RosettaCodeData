define function prime? (n :: <integer>) => (p :: <boolean>)
  case
    n == 2
      => #t;
    n == 1 | remainder(n, 2) == 0
      => #f;
    otherwise
      => let root = sqrt(as(<double-float>, n));
         iterate loop (k = 3)
           case
             remainder(n, k) == 0 => #f;
             k > root             => #t;
             otherwise            => loop(k + 2);
           end
         end
  end case
end function;

define function ascending-primes () => (primes :: <sequence>)
  let maybe = make(<deque>);
  for (k from 1 to 9)
    push-last(maybe, k)
  end;
  let primes = make(<stretchy-vector>);
  while (~empty?(maybe))
    let n = pop(maybe);
    if (prime?(n))
      add!(primes, n)
    end;
    for (k from modulo(n, 10) + 1 to 9)
      push-last(maybe, n * 10 + k)
    end
  end;
  primes
end function;

format-out("%=", ascending-primes());
