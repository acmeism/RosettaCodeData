let test n g=match [1..15]|>Seq.tryPick(solve n g) with
               Some n->n|>List.rev|>List.iter(fun n->printf "%c" (match n with N->'d'|I->'u'|G->'r'|E->'l'|L->'\u0000'));printfn " (%n moves)" (List.length n)
              |_     ->printfn "No solution found"
test 0xfe169b4c0a73d852UL 8
