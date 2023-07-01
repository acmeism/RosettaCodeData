// ADFGVX cipher. Nigel Galloway: August 23rd., 2021
let polybus=let n=[|yield! {'A'..'Z'}; yield! {'0'..'9'}|] in MathNet.Numerics.Combinatorics.GeneratePermutation 36|>Array.map(fun g->n.[g]),[|'A';'D';'F';'G';'V';'X'|]
let printPolybus(a,g)=printf "    "; g|>Array.iter(printf "%c  "); printfn ""; printfn "    ----------------"
                      g|>Array.iteri(fun n g->printf " %c|" g; [0..5]|>List.iter(fun g->printf " %c " (Array.item(n*6+g) a)); printfn "")
let c2p n g=let g=(fst>>(Array.findIndex((=) g))) n in let (n:char[])=(snd n) in [|n.[g/n.Length];n.[g%n.Length]|]
let p2c n (g:char[])=Array.item(let n=snd n in (Array.findIndex((=)g.[0]) n)*n.Length+(Array.findIndex((=)g.[1]) n))(fst n)
let fN(g:string)=let e,d=let n=g|>Seq.sort|>List.ofSeq in (g|>Seq.mapi(fun i l->(List.findIndex((=)l)n)-i)|>Array.ofSeq,n|>Seq.mapi(fun i l->(Seq.findIndex((=)l)g)-i)|>Array.ofSeq)
                 (fun i->i+(e.[i%g.Length])),(fun i->i+(d.[i%g.Length]))
let ADFGVX n (g:string)=let pE,pD=fN g
                        (fun(s:string)->let a,b=s|>Seq.collect(c2p n)|>Array.ofSeq|>Array.splitAt(2*s.Length-(2*s.Length)%g.Length)
                                        Array.append(Array.permute(pE) a)(Array.permute(fst(fN(g.[..b.Length-1]))) b)|>System.String),
                        (fun(s:string)->let a,b=s.ToCharArray()|>Array.splitAt(s.Length-(s.Length)%g.Length)
                                        Array.append(Array.permute(pD) a)(Array.permute(snd(fN(g.[..b.Length-1]))) b)|>Array.chunkBySize 2|>Array.map(p2c n)|>System.String)

printPolybus polybus
let encrypt,decrypt=ADFGVX polybus "nigel" //Using "nigel" as the key no hacker will guess that!
let n=encrypt "ATTACKAT1200AM" in printfn $"\nATTACKAT1200AM encrypted is %s{n} which decrypted is %s{decrypt n}"
