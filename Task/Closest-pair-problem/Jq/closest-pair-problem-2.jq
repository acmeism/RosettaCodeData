# P is an array of points, [x,y].
# Emit the solution in the form [dist, [P1, P2]]
def bruteForceClosestPair(P):
  (P|length) as $length
  | if $length < 2 then null
    else
      reduce range(0; $length-1) as $i
        ( null;
          reduce range($i+1; $length) as $j
            (.;
             dist(P[$i]; P[$j]) as $d
             | if . == null or $d < .[0] then [$d, [ P[$i], P[$j] ] ] else . end ) )
    end;

def closest_pair:

  def abs: if . < 0 then -. else . end;
  def ceil: floor as $floor
    | if . == $floor then $floor else $floor + 1 end;

  # xP is an array [P(1), .. P(N)] sorted by x coordinate, and
  # yP is an array [P(1), .. P(N)] sorted by y coordinate (ascending order).
  # if N <= 3 then return closest points of xP using the brute-force algorithm.
  def closestPair(xP; yP):
    if xP|length <= 3 then bruteForceClosestPair(xP)
    else
      ((xP|length)/2|ceil) as $N
      | xP[0:$N]  as $xL
      | xP[$N:]   as $xR
      | xP[$N-1][0] as $xm                        # middle
      | (yP | map(select(.[0] <= $xm ))) as $yL0  # might be too long
      | (yP | map(select(.[0] >  $xm ))) as $yR0  # might be too short
      | (if $yL0|length == $N then $yL0 else $yL0[0:$N] end) as $yL
      | (if $yL0|length == $N then $yR0 else $yL0[$N:] + $yR0 end) as $yR
      | closestPair($xL; $yL) as $pairL           #  [dL, pairL]
      | closestPair($xR; $yR) as $pairR           #  [dR, pairR]
      | (if $pairL[0] < $pairR[0] then $pairL else $pairR end) as $pair # [ dmin, pairMin]
      | (yP | map(select( (($xm - .[0])|abs) < $pair[0]))) as $yS
      | ($yS | length) as $nS
      | $pair[0] as $dmin
      | reduce range(0; $nS - 1) as $i
          ( [0, $pair];                         # state: [k, [d, [P1,P2]]]
            .[0] = $i + 1
            | until( .[0] as $k | $k >= $nS or ($yS[$k][1] - $yS[$i][1]) >= $dmin;
                       .[0] as $k
                       | dist($yS[$k]; $yS[$i]) as $d
                       | if $d < .[1][0]
                         then [$k+1, [ $d, [$yS[$k], $yS[$i]]]]
                         else .[0] += 1
                         end) )
      | .[1]
    end;
  closestPair( sort_by(.[0]); sort_by(.[1])) ;
