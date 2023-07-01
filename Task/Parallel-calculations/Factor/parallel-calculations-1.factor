USING: io kernel fry locals sequences arrays math.primes.factors math.parser channels threads prettyprint ;
IN: <filename>

:: map-parallel ( seq quot -- newseq )
    <channel> :> ch
    seq [ '[ _ quot call ch to ] "factors" spawn ] { } map-as
    dup length [ ch from ] replicate nip ;

{ 576460752303423487 576460752303423487
  576460752303423487 112272537195293
  115284584522153 115280098190773
  115797840077099 112582718962171
  112272537095293 1099726829285419 }
dup [ factors ] map-parallel
dup [ infimum ] map dup supremum
swap index swap dupd nth -rot swap nth
"Number with largest min. factor is " swap number>string append
", with factors: " append write .
