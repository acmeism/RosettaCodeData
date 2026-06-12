### Generic functions

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

def is_prime:
  . as $n
  | if ($n < 2)         then false
    elif ($n % 2 == 0)  then $n == 2
    elif ($n % 3 == 0)  then $n == 3
    elif ($n % 5 == 0)  then $n == 5
    elif ($n % 7 == 0)  then $n == 7
    elif ($n % 11 == 0) then $n == 11
    elif ($n % 13 == 0) then $n == 13
    elif ($n % 17 == 0) then $n == 17
    elif ($n % 19 == 0) then $n == 19
    else sqrt as $s
    | 23
    | until( . > $s or ($n % . == 0); . + 2)
    | . > $s
    end;

# The input to the power $exp modulo $mod, which is assumed to be positive
def modPow($exp; $mod):
  { base: (. % $mod),
    exp: $exp,
    r: 1
  }
  | until( .exp == 0;
      if .base == 0 then .r = 0 | .exp = 0
      else if .exp % 2 == 1 then .r = (.r * .base) % $mod end
      | .exp |= ((. / 2) | trunc)
      | .base |= (. * .) % $mod
      end )
  | .r;

### Fermat Pseudoprimes

def isFermatPseudoprime($a):
  if is_prime then false
  else . as $x
  | ($a | modPow($x-1; $x)) == 1
  end;


def display($n):
  "First \($n) Fermat pseudoprimes:",
  (range(1; $n+1) as $a
   | { x: 2,  count: 0 }
   | until (.count >= 20;
       if .x | isFermatPseudoprime($a)
       then .first20 += [.x]
       | .count += 1
       end
       | .x += 1 )
   | "Base \($a|lpad(2)): \(.first20|map(lpad(5))|join(" "))" ) ;

def task($limits):
  def heading: "\nCount <= \($limits | map(lpad(6)) | join(" "))";

  heading as $heading
  | $heading,
  "-" * ($heading|length - 1),
  (range(1; 21) as $a
   | "Base \($a|lpad(2)): " +
     ([foreach $limits[] as $limit ( {x: 2,  count: 0 };
         until (.x > $limit;
           if .x | isFermatPseudoprime($a) then .count += 1  end
           | .x += 1 ) )
       | .count
       | lpad(6) ]
     | join(" ") ) ) ;

display(20),
task( [12000, 25000, 50000, 100000] )
