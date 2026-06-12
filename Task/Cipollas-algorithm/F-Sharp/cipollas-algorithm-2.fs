let test=[(10I,13I);(56I,101I);(8218I,10007I);(8219I,10007I);(331575I,1000003I);(665165880I,1000000007I);(881398088036I,1000000000039I);(34035243914635549601583369544560650254325084643201I,10I**50+151I)]
test|>List.iter(fun(n,g)->match Cipolla n g with Some r->printfn "Cipolla %A %A -> %A (%A) check %A" n g r (g-r) ((r*r)%g) |_->printfn "Cipolla %A %A -> has no result" n g)
