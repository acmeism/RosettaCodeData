let rec fN g=[yield g%16; if g>15 then yield! fN(g/16)]
primes32()|>Seq.takeWhile((>)500)|>Seq.filter(fun g->let g=fN g in List.rev g=g)|>Seq.iter(printf "%0x "); printfn ""
