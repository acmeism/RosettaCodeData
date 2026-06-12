// Nigel Gallowy. March 29th., 2021
let fN=function _::_::_::n->n |_->raise(System.Exception("List has fewer than 3 elements"))
[[1..10];[1;2];[1;2;3]]|>Seq.iter(fun n->try printfn "%A->%A" n (fN n) with :? System.Exception as e->printfn "oops -> %s" (e.Message))
