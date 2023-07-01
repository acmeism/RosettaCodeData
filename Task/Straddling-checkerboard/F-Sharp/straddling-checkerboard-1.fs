(*
Encode and Decode using StraddlingCheckerboard
Nigel Galloway May 15th., 2017
*)
type G={n:char;i:char;g:System.Collections.Generic.Dictionary<(char*char),string>;e:System.Collections.Generic.Dictionary<char,string>}
       member G.encode n=n|>Seq.map(fun n->if (n='/') then G.e.['/']+string n else match (G.e.TryGetValue(n)) with |(true,n)->n|(false,_)->G.e.['/']+string n)
       member G.decode n =
         let rec fn n = seq{ if not (Seq.isEmpty n)
           then match (match Seq.head n with |g when g=G.n||g=G.i->(G.g.[(g,(Seq.item 1 n))],(Seq.skip 2 n))|g->(G.g.[('/',g)],(Seq.tail n))) with
                |(a,b) when a="/"->yield string (Seq.head b); yield! fn (Seq.tail b)
                |(a,b)           ->yield a;                   yield! fn b
         }
         fn n
let G n i g e l z=
  let a = new System.Collections.Generic.Dictionary<(char*char),string>()
  let b = new System.Collections.Generic.Dictionary<char,string>()
  Seq.iter2 (fun ng gn->a.[('/'   ,char ng)]<-string gn;b.[gn]<-ng) (List.except [n;i] z) g
  Seq.iter2 (fun ng gn->a.[(char n,char ng)]<-string gn;b.[gn]<-n+ng)                  z  e
  Seq.iter2 (fun ng gn->a.[(char i,char ng)]<-string gn;b.[gn]<-i+ng)                  z  l
  {n=char n;i=char i;g=a;e=b}
