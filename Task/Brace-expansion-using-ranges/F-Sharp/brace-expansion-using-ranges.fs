// Brace expansion using ranges. Nigel Galloway: October 6th., 2021
let fUC, fUR=System.Text.Rune.GetUnicodeCategory,(fun n->System.Text.Rune.GetRuneAt(n,0))
let fV(n,i,g,e,l,s)=let l=if l="" then 1 else int l in match l with 0->None |_->Some(n,i,g,e,int l,s)
let(|Valid|_|)(n:System.Text.RegularExpressions.Match)=let fN(g:string)=n.Groups.[g].Value in if n.Success then fV(fN "n",fN "i",fN "g",fN "e",fN "l",fN "s") else None
let fN(g:string)=let mutable g=g.EnumerateRunes() in if g.MoveNext() && not(g.MoveNext()) then true else false
let(|I|_|)(n,g)=if fN n && fN g then (let n,g=fUR n,fUR g in if fUC n=fUC g then Some(n,g) else None) else None
let(|G|_|)(n:string,g:string)=try let n,g=(int n,int g) in Some(n,g) with _->None
let(|E|_|)(n:string,g:string)=if n.[0]='0' || g.[0]='0' then match (n,g) with G(e,l)->Some(e,l,max n.Length g.Length) |_->None else None
let fL n=let fN i g e l=let n=[i..(if i>g then -l else l)..g] in if e="-" then List.rev n else n
         let fG n g=let n,buf=string n, System.Text.StringBuilder() in (for _ in 1..g-n.Length do buf.Append 0); buf.Append n; buf.ToString()
         match System.Text.RegularExpressions.Regex.Match(n,@"^(?<n>.*?){(?<i>.*?)\.\.(?<g>.*?)(\.\.(?<e>[-]+)?(?<l>[0-9]*?))?}(?<s>.*)$") with
          Valid(n,i,g,e,l,s)->match (i,g) with I(i,g)->Some(fN i.Value g.Value e l|>Seq.map(fun g->sprintf "%s%A%s" n (System.Text.Rune(g)) s))
                                              |E(i,g,z)->Some(fN i g e l|>Seq.map(fun g->sprintf "%s%s%s" n (fG g z) s))
                                              |G(i,g)->Some(fN i g e l|>Seq.map(fun g->sprintf "%s%A%s" n (string g) s)) |_->None
         |_->None
let rec expBraces n=seq{match fL n with Some n->yield!(n|>Seq.collect(expBraces)) |_->yield n}
let tests=["simpleNumberRising{1..3}.txt";"steppedNumberRising{1..6..2}.txt";"reverseSteppedNumberRising{1..6..-2}.txt";"steppedNumberDescending{20..9..2}.txt";"simpleAlphaDescending-{Z..X}.txt";"steppedDownAndPadded-{10..00..5}.txt";"minusSignFlipsSequence {030..20..-5}.txt";"combined-{Q..P}{2..1}.txt";"emoji{🌵..🌶}{🌽..🌾}etc";"li{teral";"rangeless{random}string";"rangeless{}empty";"steppedAlphaDescending-{Z..M..2}.txt";"reversedSteppedAlphaDescending-{Z..M..-2}.txt"]
tests|>List.iter(fun g->printfn $"%s{g}->"; for n in expBraces g do printfn $"    %s{n}")
