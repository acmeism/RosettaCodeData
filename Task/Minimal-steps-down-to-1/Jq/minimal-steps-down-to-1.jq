### Generic functions

def array($n): . as $in | [range(0;$n)|$in];

def max(stream): reduce stream as $x (-infinite; if $x > . then $x else . end);

def plural: if . == 1 then " " else "s" end;

### Minimal Steps
# Input: { divs, subs, limit, mins }
# where .divs and .subs are the arrays of divisors and subtractors respectively,
# and .limit the value specified for task/1;
# .mins should be an array of arrays.
def minsteps($n):
  if $n == 1
  then .mins[1] = []
  else .min = .limit
  | .p = 0
  | .q = 0
  | .op = ""
  | reduce .divs[] as $div (.;
        if ($n % $div == 0)
        then (($n/$div)|floor) as $d
        | (.mins[$d]|length + 1) as $steps
        | if $steps < .min
          then .min = $steps
          | .p = $d
          | .q = $div
          | .op = "/"
          end
        end )
  | reduce .subs[] as $sub (.;
        ($n - $sub) as $d
        | if $d >= 1
          then (.mins[$d]|length + 1) as $steps
          | if $steps < .min
            then .min = $steps
            | .p = $d
            | .q = $sub
            | .op = "-"
            end
          end)
  | .mins[$n] = ["\(.op)\(.q) -> \(.p)"] + .mins[.p]
  end ;

def task($limit):
  range(0;2) as $r
  | { divs: [2, 3],
      subs: (if $r == 0 then [1] else [2] end),
      mins: [],
      $limit
    }
  | "\nWith: Divisors: \(.divs), Subtractors: \(.subs) =>",
    "  Minimum number of steps to diminish the following numbers down to 1 is:",
    ( foreach range(1; 1+$limit) as $i (.;
        minsteps($i)  # sets .min[$i]
        | if ($i <= 10)
          then (.mins[$i]|length) as $steps
          | .emit = "    \($i): \($steps) step\($steps|plural): \(.mins[$i] | join(", "))"
          else .emit = null
          end;
        select(.emit).emit,

        # ... and when all is done:
        (select($i==$limit)
         | foreach (2000, 20000, $limit) as $lim (.;
            .max = max( .mins[0: 1 + $lim][] | length)
            | .maxs = []
            | .i = 0
            | reduce .mins[0: 1 + $lim][] as $min (.;
                if ($min|length) == .max then .maxs += [.i] end
                | .i += 1 )
            | .nums = (.maxs|length)
            | (if .nums == 1 then "is" else "are" end) as $are
            | (if .nums == 1 then "has" else "have" end) as $have
            | .emit =  "  There \($are) \(.nums) number\(.nums|plural) in the range 1-\($lim)"
            | .emit += " that \($have) maximum 'minimal steps' of \(.max):"
            | .emit += "\n   \(.maxs)";
           .emit) ) ) )
;

task(50000)
