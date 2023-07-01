//Solve Knapsack 0-1 using A* algorithm
//Nigel Galloway, August 3rd., 2018
let knapStar items maxW=
  let l=List.length items
  let p=System.Collections.Generic.SortedSet<float*int*float*float*list<int>>() //H*; level; value of items taken so far; weight so far
  p.Add (0.0,0,0.0,0.0,[])|>ignore
  let H items maxW=let rec H n g a=match g with |(_,w,v)::e->let t=n+w
                                                             if t<=maxW then H t e (a+v) else a+(v/w)*(maxW-n)
                                                |_->a
                   H 0.0 items 0.0
  let pAdd ((h,_,_,_,_) as n) bv=if h>bv then p.Add n |> ignore
  let fH n (bv,t) w' v' t'=let _,w,v=List.item n items
                           let e=max bv (if w<=(maxW-w') then v'+v else bv)
                           let rt=n::t'
                           if n+1<l then pAdd ((v'+H (List.skip (n+1) items) maxW),n+1,v',w',t') bv
                                         if w<=(maxW-w') then pAdd ((v'+v+H (List.skip (n+1) items) (maxW-w')),n+1,v'+v,w'+w,rt) bv
                           if e>bv then (e,rt) else (bv,t)
  let rec fN (bv,t)=
    let h,zl,zv,zw,zt as r=p.Max
    p.Remove r |> ignore
    if bv>=h then t else fN (fH zl (bv,t) zw zv zt)
  fN (fH 0 (0.0,[]) 0.0 0.0 [])
