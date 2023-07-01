# Compute the standard deviation of the observations
# seen so far, given the current state as input:
def standard_deviation: .ssd / .n | sqrt;

def update_state(observation):
  def sq: .*.;
  ((.mean * .n + observation) / (.n + 1)) as $newmean
  | (.ssd + .n * ((.mean - $newmean) | sq)) as $ssd
  | { "n": (.n + 1),
      "ssd":  ($ssd + ((observation - $newmean) | sq)),
      "mean": $newmean }
;

def initial_state: { "n": 0, "ssd": 0, "mean": 0 };

# Given an array of observations presented as input:
def simulate:
  def _simulate(i; observations):
    if (observations|length) <= i then empty
    else update_state(observations[i])
      | standard_deviation, _simulate(i+1; observations)
    end ;
  . as $in | initial_state | _simulate(0; $in);

# Begin:
simulate
