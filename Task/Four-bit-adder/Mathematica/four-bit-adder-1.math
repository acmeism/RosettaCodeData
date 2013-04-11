and[a_, b_] := Max[a, b];
or[a_, b_] := Min[a, b];
not[a_] := 1 - a;
xor[a_, b_] := or[and[a, not[b]], and[b, not[a]]];
halfadder[a_, b_] := {xor[a, b], and[a, b]};
fulladder[a_, b_, c0_] := Module[{s, c, c1},
   {s, c} = halfadder[c0, a];
   {s, c1} = halfadder[s, b];
   {s, or[c, c1]}];
fourbitadder[{a3_, a2_, a1_, a0_}, {b3_, b2_, b1_, b0_}] :=
  Module[{s0, s1, s2, s3, c0, c1, c2, c3},
   {s0, c0} = fulladder[a0, b0, 0];
   {s1, c1} = fulladder[a1, b1, c0];
   {s2, c2} = fulladder[a2, b2, c1];
   {s3, c3} = fulladder[a3, b3, c2];
   {{s3, s2, s1, s0}, c3}];
