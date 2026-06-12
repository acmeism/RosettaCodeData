let n=fromSeq [85; 57; 51; 50; 86; 39; 95; 49; 44; 48; 21; 83; 11; 59; 88; 66; 4; 40; 24; 82; 63; 22; 37; 32; 91; 74; 28; 75; 62; 81]
printfn "Populated Red Black Tree"; printN n "" "X"
let g=delSeq [32; 40; 57; 63; 66; 75; 86; 59; 83; 51; 24; 62; 82; 39; 37] n
printfn "\nRed Black Tree after deletions"; printN g "" "X"
