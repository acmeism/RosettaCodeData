// Boustrophedon transform. Nigel Galloway:October 26th., 2023
let fG n g=let rec fG n g=[match n with h::[]->yield g+h |h::t->yield g+h; yield! fG t (g+h)] in [yield g; yield! fG n g]|>List.rev
let Boustrophedon n=Seq.scan(fun n g->fG n g)[Seq.head n] (Seq.tail n)|>Seq.map(List.head)

