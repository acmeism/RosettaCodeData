def _nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

# Emit the inventory sequence ad infinitum
def inventory_sequence:
  {num: 0,
   emit: 0,
   inventory: {} }
   | foreach range(0; infinite) as $n (.;
       .emit = (.inventory[.num|tostring] // 0)
       | if .emit == 0 then .num = 0 else .num += 1 end
       | .inventory[.emit|tostring] += 1 )
   | .emit ;

# Report on the progress of an arbitrary sequence, indefinitely
# Emit [.next, $x, .n]
def probe(s; $gap):
  foreach s as $x ({n: 0, next: $gap};
    .n += 1
    | if $x >= .next then .emit = {next, $x, n} | .next += $gap
      else .emit = null
      end)
  | select(.emit).emit;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def task($n):
  [limit($n; inventory_sequence)] | _nwise(10) | map(lpad(3)) | join(" ");

task(100),
"",
(limit(10; probe(inventory_sequence; 1000))
 | "First element >= \(.next) is \(.x) at index \(.n - 1)")
