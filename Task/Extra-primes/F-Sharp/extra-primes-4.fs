primes64()|>Seq.skipWhile((>)7770000000L)|>Seq.takeWhile((>)7777777777L)|>List.ofSeq|>List.filter izXprime|>List.rev|>List.take 10|>List.rev|>List.iter(printf "%d ");printfn ""
