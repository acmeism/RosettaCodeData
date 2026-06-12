// Manacher Function. Nigel Galloway: October 1st., 2020
let Manacher(s:string) = let oddP,evenP=Array.zeroCreate s.Length,Array.zeroCreate s.Length
                         let rec fN i g e (l:int[])=match g>=0 && e<s.Length && s.[g]=s.[e] with true->l.[i]<-l.[i]+1; fN i (g-1) (e+1) l |_->()
                         let rec fGo n g Ʃ=match Ʃ<s.Length with
                                            false->oddP
                                           |_->if Ʃ<=g then oddP.[Ʃ]<-min (oddP.[n+g-Ʃ]) (g-Ʃ)
                                               fN Ʃ (Ʃ-oddP.[Ʃ]-1) (Ʃ+oddP.[Ʃ]+1) oddP
                                               match (Ʃ+oddP.[Ʃ])>g with true->fGo (Ʃ-oddP.[Ʃ]) (Ʃ+oddP.[Ʃ]) (Ʃ+1) |_->fGo n g (Ʃ+1)
                         let rec fGe n g Ʃ=match Ʃ<s.Length with
                                            false->evenP
                                           |_->if Ʃ<=g then evenP.[Ʃ]<-min (evenP.[n+g-Ʃ]) (g-Ʃ)
                                               fN Ʃ (Ʃ-evenP.[Ʃ]) (Ʃ+evenP.[Ʃ]+1) evenP
                                               match (Ʃ+evenP.[Ʃ])>g with true->fGe (Ʃ-evenP.[Ʃ]+1) (Ʃ+evenP.[Ʃ]) (Ʃ+1) |_->fGe n g (Ʃ+1)
                         (fGo 0 -1 0,fGe 0 -1 0)
