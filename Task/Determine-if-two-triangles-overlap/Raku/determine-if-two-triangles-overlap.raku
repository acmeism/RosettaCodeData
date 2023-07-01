# Reference:
# https://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle
# https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/

sub if-overlap ($triangle-pair) {
   my (\A,\B) = $triangle-pair;
   my Bool $result = False;

   sub sign (\T) {
      return (T[0;0] - T[2;0]) × (T[1;1] - T[2;1]) -
             (T[1;0] - T[2;0]) × (T[0;1] - T[2;1]);
   }

   sub point-in-triangle (\pt, \Y --> Bool) {
      my $d1 = sign (pt, Y[0], Y[1]);
      my $d2 = sign (pt, Y[1], Y[2]);
      my $d3 = sign (pt, Y[2], Y[0]);

      my $has_neg = [or] $d1 < 0, $d2 < 0, $d3 < 0;
      my $has_pos = [or] $d1 > 0, $d2 > 0, $d3 > 0;

      return not ($has_neg and $has_pos);
   }

   sub orientation(\P, \Q, \R --> Int) {
      my \val = (Q[1] - P[1]) × (R[0] - Q[0]) -
                (Q[0] - P[0]) × (R[1] - Q[1]);

      return 0 if val == 0;     # colinear
      return val > 0 ?? 1 !! 2; # clock or counterclock wise
   }

   sub onSegment(\P, \Q, \R --> Bool) {
      Q[0] ≤ max(P[0], R[0]) and Q[0] ≥ min(P[0], R[0]) and
      Q[1] ≤ max(P[1], R[1]) and Q[1] ≥ min(P[0], R[1])
         ?? True !! False
   }

   sub intersect(\A,\B,\C,\D --> Bool) {
      my \o1 = orientation A, C, D;
      my \o2 = orientation B, C, D;
      my \o3 = orientation A, B, C;
      my \o4 = orientation A, B, D;

         o1 != o2 and o3 != o4
      or o1 ==  0 and onSegment A, C, D
      or o2 ==  0 and onSegment B, C, D
      or o3 ==  0 and onSegment A, B, C
      or o4 ==  0 and onSegment A, B, D
         ?? True !! False
   }

   for ^3 {
      { $result = True; last } if
          point-in-triangle A.[$^i], B or
          point-in-triangle B.[$^i], A ;
   }

   unless $result {
      $result = True if
          intersect A.[0], A.[1], B.[0], B.[1] or
          intersect A.[0], A.[1], B.[0], B.[2]
   }

   say "{A.gist} and {B.gist} do{' NOT' unless $result} overlap.";
}

my \DATA = [
   [ [(0,0),(5,0),(0,5)]   ,  [(0,0),(5,0),(0,6)]     ],
   [ [(0,0),(0,5),(5,0)]   ,  [(0,0),(0,5),(5,0)]     ],
   [ [(0,0),(5,0),(0,5)]   ,  [(-10,0),(-5,0),(-1,6)] ],
   [ [(0,0),(5,0),(2.5,5)] ,  [ (0,4),(2.5,-1),(5,4)] ],
   [ [(0,0),(1,1),(0,2)]   ,  [(2,1),(3,0),(3,2)]     ],
   [ [(0,0),(1,1),(0,2)]   ,  [(2,1),(3,-2),(3,4)]    ],
   [ [(0,0),(1,0),(0,1)]   ,  [(1,0),(2,0),(1,1)]     ]
];

if-overlap $_ for DATA ;
