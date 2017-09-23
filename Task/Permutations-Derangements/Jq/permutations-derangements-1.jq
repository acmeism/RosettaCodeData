def derangements:

  # In order to reference the original array conveniently, define _derangements(ary):
  def _derangements(ary):
    # We cannot put the i-th element in the i-th place:
    def deranged:  # state: [i, available]
      .[0] as $i | .[1] as $in
      | if $i == (ary|length) then []
        else
        ($in[] | select (. != ary[$i])) as $j
        |  [$j] + ([$i+1, ($in - [$j])] | deranged)
        end
      ;
    [0,ary]|deranged;
    . as $in | _derangements($in);

def subfact:
  if . == 0 then 1
  elif . == 1 then 0
  else (.-1) * (((.-1)|subfact) + ((.-2)|subfact))
  end;

# Avoid creating an array just to count the items in a stream:
def count(g): reduce g as $i (0; . + 1);
