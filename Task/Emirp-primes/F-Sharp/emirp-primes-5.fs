// count # of emirps with n = 2 to 7 digits. Nigel Galloway: August 8th., 2018
let n=emirp |> Seq.takeWhile(fun n->n<10000000) |> Seq.countBy(fun n->match n with |n when n>999999->7
                                                                                   |n when n> 99999->6
                                                                                   |n when n>  9999->5
                                                                                   |n when n>   999->4
                                                                                   |n when n>    99->3
                                                                                   |_              ->2)
for n,g in n do printfn "%d -> %d" n g
