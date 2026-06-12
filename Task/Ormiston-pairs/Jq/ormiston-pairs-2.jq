def digits: tostring | explode;

def ormiston_pairs($limit):
  ($limit | primeSieve | map(select(.))) as $primes
  | range(0; $primes|length-1) as $i
  | $primes[$i]   as $p1
  | $primes[$i+1] as $p2
  | select( ($p2|digits|sort) == ($p1|digits|sort) )
  | [$p1, $p2] ;

def task($limit):
  reduce ormiston_pairs($limit) as $pair (
    {count:0, orm30: [], counts: [], j: 1e5};
    if .count < 30 then .orm30 += [$pair] else . end
    | if $pair[0] >= .j
      then .counts += [.count]
      | .j *= 10
      else .
      end
    | .count += 1 )
  | .counts += [.count]
  | ("First 30 Ormiston pairs:", (.orm30 | map(tostring) | _nwise(3) | join(" "))),
    "",
    foreach range(0; .counts|length) as $i (.j = 1e5;
      .emit = "\(.counts[$i]) Ormiston pairs before \(.j)"
      | .j *= 10;
      select(.emit).emit) );

task(1e7) # ten million
