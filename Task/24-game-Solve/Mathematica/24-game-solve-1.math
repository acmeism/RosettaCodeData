treeR[n_] := Table[o[trees[a], trees[n - a]], {a, 1, n - 1}]
treeR[1] := n
tree[n_] :=
 Flatten[treeR[n] //. {o[a_List, b_] :> (o[#, b] & /@ a),
    o[a_, b_List] :> (o[a, #] & /@ b)}]
game24play[val_List] :=
 Union[StringReplace[StringTake[ToString[#, InputForm], {10, -2}],
     "-1*" ~~ n_ :> "-" <> n] & /@ (HoldForm /@
      Select[Union@
        Flatten[Outer[# /. {o[q_Integer] :> #2[[q]],
             n[q_] :> #3[[q]]} &,
          Block[{O = 1, N = 1}, # /. {o :> o[O++], n :> n[N++]}] & /@
           tree[4], Tuples[{Plus, Subtract, Times, Divide}, 3],
          Permutations[Array[v, 4]], 1]],
       Quiet[(# /. v[q_] :> val[[q]]) == 24] &] /.
     Table[v[q] -> val[[q]], {q, 4}])]
