include "rational" {search: "."}; # see [[Arithmetic/Rational#jq]]:

# Preliminaries
# for gojq
def idivide($j):
  . as $i
  | ($i % $j) as $mod
  | ($i - $mod) / $j ;

# use idivide for precision
def binomial(n; k):
  if k > n / 2 then binomial(n; n-k)
  else reduce range(1; k+1) as $i (1; . * (n - $i + 1) | idivide($i))
  end;

# pretty print a Rational assumed to have the {n,d} form
def rpp:
  if .n == 0 then "0"
  elif .d == 1 then .n | tostring
  else "\(.n)/\(.d)"
  end;

# The following definition reflects the "modern view" that B(1) is 1 // 2
def bernoulli:
  if type != "number" or . < 0 then "bernoulli must be given a non-negative number vs \(.)" | error
  else . as $n
  | reduce range(0; $n+1) as $i ([];
        .[$i] = r(1; $i + 1)
        | reduce range($i; 0; -1) as $j (.;
            .[$j-1] = rmult($j;  rminus(.[$j-1]; .[$j])) ) )
  | .[0]  # the modern view
  end;


# The task
def faulhaber($p):
  # The traditional view:
  def bernouilli($n):
     $n | bernouilli | if $n==1 then rminus else . end;

  r(1; $p+1) as $q
  | { sign: -1 }
  | reduce range(0; 1+$p) as $j (.;
      .sign *= -1
      | r(binomial($p+1; $j); 1) as $b
      | ([$q, .sign, $b, ($j|bernoulli)] | rmult) as $coeff
      | if requal($coeff; r(0;1))|not
        then .emit +=
           (if $j == 0
            then (if   requal($coeff; r( 1;1)) then ""
                  elif requal($coeff; r(-1;1)) then "-"
                  else "\($coeff|rpp) " end)
            else (if requal($coeff; r(1;1)) then " + "
                  elif requal($coeff; r(-1;1)) then " - "
                  elif r(0;1)|rlessthan($coeff) then " + \($coeff|rpp) "
                  else " - \($coeff|rminus|rpp) "
                  end)
            end)
        | ($p + 1 - $j) as $pwr
        | .emit += (if 1 < $pwr then "n^\($pwr)" else "n" end)
        else .
        end )
 | .emit ;

range(0;10) |  "\(.) : \(faulhaber(.))"
