// Generate humble numbers. Nigel Galloway: June 18th., 2020
let     fN g=let mutable n=1UL in (fun()->n<-n*g;n)
let     fI (n:uint64) g=let mutable q=n in (fun()->let t=q in q<-n*g();t)
let     fG n g=let mutable vn,vg=n(),g() in fun()->match vg<vn with true->let t=vg in vg<-g();t |_->let t=vn in vn<-n();t
let rec fE n=seq{yield n();yield! fE n}
let     fL n g=let mutable vn,vg,v=n(),g(),None
               fun()->match v with
                       Some n->v<-None;n
                      |_->match vg() with
                           r when r<vn->r
                          |r->vg<-fG vg (fI vn (g()));vn<-n();v<-Some r;vg()
let humble = seq{yield 1UL;yield! fE(fL (fN 7UL) (fun()->fL (fN 5UL) (fun()->fL (fN 3UL) (fun()->fN 2UL))))}
