// Generate Van Eck's Sequence. Nigel Galloway: June 19th., 2019
let ecK()=let n=System.Collections.Generic.Dictionary<int,int>()
          Seq.unfold(fun (g,e)->Some(g,((if n.ContainsKey g then let i=n.[g] in n.[g]<-e;e-i else n.[g]<-e;0),e+1)))(0,0)
