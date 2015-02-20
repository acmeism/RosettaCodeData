   HERMITIAN;NORMAL;UNITARY
+--------+-----+--------------------------+
|   3 2j1|1 1 0|   0.707107   0.707107   0|
|2j_1   1|0 1 1|0j_0.707107 0j0.707107   0|
|        |1 0 1|          0          0 0j1|
+--------+-----+--------------------------+
   NB. In J, PjQ is P + Q*i and the 0.7071... is sqrt(2)

   hermitian=: -: ct
   normal =: (X~ -: X) ct
   unitary=: ct -: %.

   (hermitian,normal,unitary)&.>HERMITIAN;NORMAL;UNITARY
+-----+-----+-----+
|1 1 0|0 1 0|0 1 1|
+-----+-----+-----+
