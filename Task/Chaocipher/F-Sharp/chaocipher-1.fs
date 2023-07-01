// Implement Chaocipher. Nigel Galloway: July 13th., 2019
let pL n=function g when g=n->0 |g when g=(n+1)%26->13 |g->let x=(25+g-n)%26 in if x<13 then x else x+1
let pR n=function g when g=n->25 |g when g=(n+3)%26->13 |g when g=(n+1)%26->0 |g when g=(n+2)%26->1 |g->let x=(24+g-n)%26 in if x<13 then x else x+1
let encrypt lW rW txt=Array.scan(fun (lW,rW) t->let n=Array.findIndex(fun n->n=t) rW in ((Array.permute(pL n) lW,(Array.permute(pR n) rW))))(lW,rW) txt
                        |>Array.skip 1|>Array.map(fun(n,_)->n.[0])|>System.String
let decrypt lW rW txt=Array.scan(fun (_,lW,rW) t->let n=Array.findIndex(fun n->n=t) lW in ((Array.item n rW,Array.permute(pL n) lW,(Array.permute(pR n) rW))))('0',lW,rW) txt
                        |>Array.skip 1|>Array.map(fun(n,_,_)->n)|>System.String
