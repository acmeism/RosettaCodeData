# Output: if all the prisoners succeed, emit true, otherwise false
def optimalStrategy($drawers; np):
  # Does prisoner $p succeed?
  def succeeds($p):
    first( foreach range(0; np/2) as $d ({prev: $p};
             .curr = ($drawers[.prev])
             | if .curr == $p
               then .success = true
               else .prev = .curr
               end;
             select(.success))) // false;

  all( range(0; np); succeeds(.) );

# Output: if all the prisoners succeed, emit true, otherwise false
def randomStrategy($drawers; np):
  (np/2) as $maxd
  # Does prisoner $p succeed?
  | def succeeds($p):
      {success: false }
      | first(.d = 0
              | .opened = []
              | until( (.d >= $maxd) or .success;
                  (np|prn) as $n
                  | if .opened[$n] then .
                    else .opened[$n] = true
                    | .d += 1
                    | .success = $drawers[$n] == $p
                    end )
              | select(.success) ) // false;

  all( range(0; np); succeeds(.) );


def run(strategy; trials; np):
  count(range(0; trials)
    | ([range(0;np)] | knuthShuffle) as $drawers
    | select (if strategy == "optimal"
              then optimalStrategy($drawers; np)
              else randomStrategy($drawers; np)
              end ) );

def task($trials):
  def percent: "\(10000 * . | round / 100)%";
  def summary(strategy):
    "With \(strategy) strategy: pardoned = \(.), relative frequency = \(./$trials | percent)";

  (10, 100) as $np
  | "Results from \($trials) trials with \($np) prisoners:",
    (run("random";  $trials; $np) | summary("random")),
    (run("optimal"; $trials; $np) | summary("optimal")),
    ""
;

task(100000)
