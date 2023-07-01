//Nigel Galloway August 14th., 2018
let cP ng=Seq.foldBack(fun n g->[for n' in n do for g' in g do yield n'::g']) ng [[]]
