// Move-to-front algorithm . Nigel Galloway: March 1st., 2021
let fN g=List.permute(fun n->match compare n g with 0->0 |1->n |_->n+1)
let decode n=let rec fG n g=[|match n with n::t->yield List.item n g; yield! fG t (fN n g)|_->()|] in fG n ['a'..'z']|>System.String
let encode n=let rec fG n g=[match n with n::t->let n=g|>List.findIndex((=)n) in yield n; yield! fG t (fN n g)|_->()]
             fG ((string n).ToCharArray()|>List.ofArray) ['a'..'z']
["broood";"bananaaa";"hiphophiphop"]|>List.iter(fun n->let i=encode n in let g=decode i in printfn "%s->%A->%s check=%A" n i g (n=g))
