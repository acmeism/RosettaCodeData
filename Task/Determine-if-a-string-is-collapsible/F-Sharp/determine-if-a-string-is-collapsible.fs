// Collapse a String. Nigel Galloway: June 9th., 2020
//As per the task description a function which 'determines if a character string is collapsible' by testing if any consecutive characters are the same.
let isCollapsible n=n|>Seq.pairwise|>Seq.tryFind(fun(n,g)->n=g)
//As per the task description a function which 'if the string is collapsable, collapses the string (by removing immediately repeated characters).
let collapse n=match isCollapsible n with
                Some _->let i=Seq.head n
                        let fN=let mutable g=i in (fun n->if n=g then false else g<-n; true)
                        let g=System.String([|yield i;yield! Seq.tail n|>Seq.filter fN|])
                        printfn "<<<%s>>> (length %d) colapses to <<<%s>>> (length %d)" n n.Length g g.Length
               |     _->printfn "<<<%s>>> (length %d) does not colapse" n n.Length

collapse ""
collapse "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln "
collapse "..1111111111111111111111111111111111111111111111111111111111111117777888"
collapse "I never give 'em hell, I just tell the truth, and they think it's hell. "
collapse "                                                    --- Harry S Truman  "
collapse "withoutConsecutivelyRepeatedCharacters"
