// Pattern Matching. Nigel Galloway: January 15th., 2021
type colour= |Red |Black
type rbT<'N>= |Empty |N of colour * rbT<'N> * rbT<'N> * 'N
let repair=function |Black,N(Red,N(Red,ll,lr,lv),rl,v),rr,rv
                    |Black,N(Red,ll,N(Red,lr,rl,v),lv),rr,rv
                    |Black,ll,N(Red,N(Red,lr,rl,v),rr,rv),lv
                    |Black,ll,N(Red,lr,N(Red,rl,rr,rv),v),lv->N(Red,N(Black,ll,lr,lv),N(Black,rl,rr,rv),v)
                    |i,g,e,l->N(i,g,e,l)
let insert item rbt = let rec insert=function
                        |Empty->N(Red,Empty,Empty,item)
                        |N(i,g,e,l) as node->if item>l then repair(i,g,insert e,l) elif item<l then repair(i,insert g,e,l) else node
                      match insert rbt with N(_,g,e,l)->N(Black,g,e,l) |_->Empty
