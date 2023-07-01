// Determine if a string is squeezable. Nigel Galloway: June 9th., 2020
let squeeze n i=if String.length n=0 then None else
                let fN=let mutable g=n.[0] in (fun n->if n=i && n=g then false else g<-n; true)
                let fG=n.[0..0]+System.String(n.[1..].ToCharArray()|>Array.filter fN)
                if fG.Length=n.Length then None else Some fG
let isSqueezable n g=match squeeze n g with
                      Some i->printfn "%A squeezes <<<%s>>> (length %d) to <<<%s>>> (length %d)" g n n.Length i i.Length
                     |_->printfn "%A does not squeeze <<<%s>>> (length %d)" g n n.Length

isSqueezable "" ' '
isSqueezable "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln " '-'
isSqueezable "..1111111111111111111111111111111111111111111111111111111111111117777888" '7'
isSqueezable "I never give 'em hell, I just tell the truth, and they think it's hell. " '.'
let fN=isSqueezable "                                                    --- Harry S Truman  " in fN ' '; fN '-'; fN 'r'
