say (^200).grep(-> $n {all (2,3).map({$n.base($_).comb.sum.is-prime}) }).batch(10)».fmt('%3d').join: "\n";
