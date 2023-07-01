//I provide 2 fuctions D2N takes a radix and an integer returning a sequence of integers
//                     N2D takse a radix and a sequence of integers returning an integer
//Note that the radix may be either positive or negative.  Nigel Galloway, May 10th., 2019
let D2N n g=if g=0 then seq[0] else Seq.unfold(fun g->let α,β=g/n,g%n in match (compare g 0,β) with
                                                                          (0,_)->None
                                                                         |(1,_) |(_,0)->Some(β,α)
                                                                         |_->Some(g-(α+1)*n,α+1)) g|>Seq.rev
let N2D n g=fst(Seq.foldBack(fun g (Σ,α)->(Σ+α*g,n*α)) g (0,1))
