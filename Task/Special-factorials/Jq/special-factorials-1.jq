# for integer precision:
def power($b): . as $a | reduce range(0;$b) as $i (1; . * $a);

def sf:
  . as $n
  | if $n < 2 then 1
    else  {sfact: 1, fact: 1}
    | reduce range (2;1+$n) as $i (.;
        .fact *=  $i
        | .sfact *= .fact)
    | .sfact
    end;

def H:
  . as $n
  | if $n < 2 then 1
    else
      reduce range(2;1+$n) as $i ( {hfact: 1};
        .hfact *= ($i | power($i)))
    | .hfact
    end;

def af:
  . as $n
  | if $n < 1 then 0
    else {afact: 0, fact: 1, sign: (if $n%2 == 0 then -1 else 1 end)}
    | reduce range(1; 1+$n) as $i (.;
        .fact *= $i
        | .afact += .fact * .sign
        | .sign *= -1)
    | .afact
    end;

def ef: # recursive
  . as $n
  | if $n < 1 then 1
    else $n | power( ($n-1)|ef )
    end;

def rf:
  . as $n
  | {i: 0, fact: 1}
  | until( .fact >= $n;
           .i += 1
           | .fact = .fact * .i)
  | if .fact > $n then null else .i end;
