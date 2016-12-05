# a and b should be arrays:
def permutationTest(a; b):

  def normalize(a;b):  # mainly to avoid having to compute $sumab
    (a|add) as $sa
    | (b|add) as $sb
    | (($sa + $sb)/((a|length) + (b|length))) as $avg
    | [(a | map(.-$avg)), (b | map(.-$avg))];

  # avg(a) - avg(b) (assuming ab==a+b and avg(ab) is 0)
  def statistic(ab; a):
    (a | add) as $suma
    # (ab|add) should be 0, by normalization
    | ($suma / (a|length)) +
      ($suma / ((ab|length) - (a|length)));

  normalize(a;b)
  | (a + b) as $ab                               # pooled observations
  | .[0] as $a | .[1] as $b
  | statistic($ab; $a) as $t_observed            # observed difference in means
  | reduce ($ab|combination($a|length)) as $perm # for each combination...
      ([0,0];                                    # state: [under,count]
       if statistic($ab; $perm) <= $t_observed then .[0] += 1 else . end
       | .[1] += 1 )
  | .[0] * 100.0 / .[1]                         # under/count
;
