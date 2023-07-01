// Populate an array with values of Hofstadter Q sequence. Nigel Galloway: August 26th., 2020
let fQ N=let g=Array.length N in N.[0]<-1; N.[1]<-1;(for g in 2..g-1 do N.[g]<-N.[g-N.[g-1]]+N.[g-N.[g-2]])
