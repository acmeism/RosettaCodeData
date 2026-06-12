primes64()|>Seq.takeWhile((>)1000000000L)|>Seq.rev|>Seq.filter izXprime|>Seq.take 10|>Seq.rev|>Seq.iter(printf "%d ");printfn ""
