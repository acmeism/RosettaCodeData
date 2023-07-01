# Emit an unbounded stream of points of the Babylonian spiral:
def babylonianSpiral:

  def heading($x):
    def tau: 6.283185307179586;
    # Note: the Python modulo operator is not the same as Wren's or jq's
    fmod($x + tau; tau);

  [0,0],
  [0,1],
  ( { dxys: [0,1],   # the last point
       dsq : 1,
       sumx: 0,
       sumy: 1 }
    | foreach range(2; infinite) as $k (.;
         .dxys as [ $x, $y ]
        | atan2($y; $x) as $theta
        | .candidates = []
        | until(.candidates != [];
            .dsq += 1
            | .i = 0
            | until(.i >= $k;
                (.i*.i) as $a
                | if $a > ((.dsq/2)|floor) then .i = $k       # i.e., break
                  else .j = (.dsq|sqrt|floor) + 1
                  | until(.j <= 0;
                      (.j*.j) as $b
                      | if ($a + $b) < .dsq then .j = -1      # i.e., break
                        elif ($a + $b) == .dsq
                        then .candidates += [ [.i, .j], [-.i, .j], [.i, -.j], [-.i, -.j],
                                              [.j, .i], [-.j, .i], [.j, -.i], [-.j, -.i] ]
                        else .
                        end
                        | .j += -1 )
                  | .i += 1
                  end ) )
        # Python: lambda d: (θ - atan2(d[1], d[0])) % tau
        | .dxys = (.candidates | min_by( heading( ($theta - atan2(.[1]; .[0])) ) ))
        | .sumx += .dxys[0]
        | .sumy += .dxys[1];
        [.sumx, .sumy] )
  );

# Emit a stream of the first $n points:
def Points($n):
  limit($n; babylonianSpiral);
