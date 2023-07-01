// Populate R and S with values of Hofstadter Figure Figure sequence. Nigel Galloway: August 28th., 2020
let fF q=let R,S=Array.zeroCreate<int>q,Array.zeroCreate<int>q
         R.[0]<-1;S.[0]<-2
         let rec fN n g=match n=q with true->(R,S)
                                      |_->R.[n]<-R.[n-1]+S.[n-1]
                                          match S.[n-1]+1 with i when i<>R.[g]->S.[n]<-i; fN (n+1) g
                                                              |i->S.[n]<-i+1; fN (n+1) (g+1)
         fN 1 1
