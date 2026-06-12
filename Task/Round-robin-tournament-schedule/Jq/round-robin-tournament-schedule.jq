def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def rotate: .[-1:] + .[:-1];

def roundRobin($n):
  {$n, lst: [range(2; $n+1)]}
  | if $n % 2 == 1
    then .lst += [0]   # 0 denotes a bye
    | .n += 1
    end
  | foreach range(1; .n) as $r (.;
        .emit = "Round \($r|lpad(3)): "
        | ([1] + .lst) as $lst2
        | reduce range(0; .n/2) as $i (.;
            .emit += " (\($lst2[$i]|lpad(2)) vs \($lst2[.n - 1 - $i]|lpad(2)))")
        | .lst |= rotate )
   | .emit ;

"Round robin for 12 players:",
roundRobin(12),
"\n\nRound robin for 5 players (0 denotes a bye):\n",
roundRobin(5)
