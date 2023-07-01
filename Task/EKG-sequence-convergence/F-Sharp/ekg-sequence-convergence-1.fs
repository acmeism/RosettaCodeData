// Generate EKG Sequences. Nigel Galloway: December 6th., 2018
let EKG            n=seq{
  let fN,fG=let    i=System.Collections.Generic.Dictionary<int,int>()
            let fN g=(if not (i.ContainsKey g) then i.[g]<-g);(g,i.[g])
            ((fun  e->i.[e]<-i.[e]+e), (fun  l->l|>List.map fN))
  let fU           l= pCache|>Seq.takeWhile(fun n->n<=l)|>Seq.filter(fun n->l%n=0)|>List.ofSeq
  let rec EKG l (α,β)=seq{let b=fU β in if (β=n||β<snd((fG b|>List.maxBy snd))) then fN α;        yield! EKG l (fG l|>List.minBy snd)
                                                                                else fN α;yield β;yield! EKG b (fG b|>List.minBy snd)}
  yield! seq[1;n]; let g=fU n in yield! EKG g (fG g|>Seq.minBy snd)}
let EKGconv n g=Seq.zip(EKG n)(EKG g)|>Seq.skip 2|>Seq.scan(fun(n,i,g,e)(l,β)->(Set.add l n,Set.add β i,l,β))(set[1;n],set[1;g],0,0)|>Seq.takeWhile(fun(n,i,g,e)->g<>e||n<>i)
