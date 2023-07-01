# If $p is null, then call `subrand`,
# which sets .x as the PRN and which expects the the input to
# be the PRNG state, which is updated.
def subrandSeed($p):

  def subrand:
    if (.si == .sj) then subrandSeed(0) else . end
    | .si |= (if . == 0 then 54 else . - 1 end)
    | .sj |= (if . == 0 then 54 else . - 1 end)
    | .mod as $mod
    | .x = ((.state[.si] - .state[.sj]) | if . < 0 then . + $mod else . end)
    | .state[.si] = .x ;

  if $p == null then subrand
  else
  {mod: 1e9,  state: [],  si: 0,  sj: 0,  p: $p,  p2: 1,  j: 21}
  | .state[0] = ($p % .mod)
  | reduce range(1; 55) as $i (.;
        if .j >= 55 then .j += -55 else . end
        | .state[.j] = .p2
        | .p2 = .p - .p2
        | if .p2 < 0 then .p2 = .p2 + .mod else . end
        | .p = .state[.j]
        | .j += 21)
  | .si = 0
  | .sj = 24
  | reduce range(1; 166) as $i (.; subrand)
  end;

def subrand:
  subrandSeed(null);

subrandSeed(292929)
| foreach range(0; 10) as $i (.;
    subrand;
    "r[\($i+220)] = \(.x)")
