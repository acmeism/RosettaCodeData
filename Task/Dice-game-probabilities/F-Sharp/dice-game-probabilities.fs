// Dice game probabilities. Nigel Galloway: March 31st., 2026
let r=new System.Random()
let fG n g=List.init n (fun _->r.Next(g)+1)|>List.sum
let fN i g e l=Seq.init 1000000 (fun _->(fG i g),(fG e l))|>Seq.filter(fun(n,g)->n>g)|>Seq.length
printfn "Player 1 had 9 4 sided dice, Player 2 had 6 6 sided dice->Player 1 won %A percent of the time." (float (fN 9 4 6 6)/10000.0)
printfn "Player 1 had 5 10 sided dice, Player 2 had 6 7 sided dice->Player 1 won %A percent of the time." (float (fN 5 10 6 7)/10000.0)
