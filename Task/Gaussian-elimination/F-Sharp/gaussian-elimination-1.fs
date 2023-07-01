// Gaussian Elimination. Nigel Galloway: February 2nd., 2019
let gelim augM=
  let f=List.length augM
  let fG n (g:bigint list) t=n|>List.map(fun n->List.map2(fun n g->g-n)(List.map(fun n->n*g.[t])n)(List.map(fun g->g*n.[t])g))
  let rec fN i (g::e as l)=
    match i with i when i=f->l|>List.mapi(fun n (g:bigint list)->(g.[f],g.[n]))
                |_->fN (i+1) (fG e g i@[g])
  fN 0 augM
