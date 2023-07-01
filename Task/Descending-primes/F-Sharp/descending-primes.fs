// Descending primes. Nigel Galloway: April 19th., 2022
[2;3;5;7]::List.unfold(fun(n,i)->match n with []->None |_->let n=n|>List.map(fun(n,g)->[for n in n..9->(n+1,i*n+g)])|>List.concat in Some(n|>List.choose(fun(_,n)->if isPrime n then Some n else None),(n|>List.filter(fst>>(>)10),i*10)))([(4,3);(2,1);(8,7)],10)
  |>List.concat|>List.sort|>List.iter(printf "%d "); printfn ""
