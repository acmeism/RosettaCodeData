//A functional implementation of Evolutionary algorithm
//Nigel Galloway February 7th., 2018
let G=System.Random 23
let fitness n=Array.fold2(fun a n g->if n=g then a else a+1) 0 n ("METHINKS IT IS LIKE A WEASEL".ToCharArray())
let alphabet="QWERTYUIOPASDFGHJKLZXCVBNM ".ToCharArray()
let mutate (n:char[]) g=Array.iter(fun g->n.[g]<-alphabet.[G.Next()%27]) (Array.init g (fun _->G.Next()%(Array.length n)));n
let nextParent n g=List.init 500 (fun _->mutate (Array.copy n) g)|>List.minBy fitness
let evolution n=let rec evolution n g=match fitness n with |0->(0,n)::g |l->evolution (nextParent n ((l/2)+1)) ((l,n)::g)
                evolution n []
let n = evolution (Array.init 28 (fun _->alphabet.[G.Next()%27]))
