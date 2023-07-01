// Generate Pi as above using unfold. Nigel Galloway: March 15th., 2022
let π()=Seq.unfold(fun(q,r,t,k,n,l)->Some(if 4I*q+r-t < n*t then(Some(int n),((10I*q),(10I*(r-n*t)),t,k,((10I*(3I*q+r))/t-10I*n),l)) else (None,((q*k),((2I*q+r)*l),(t*l),(k+1I),((q*(7I*k+2I)+r*l)/(t*l)),(l+2I)))))(1I,0I,1I,1I,3I,3I)|>Seq.choose id
π()|>Seq.take 767|>Seq.iter(printf "%d")
