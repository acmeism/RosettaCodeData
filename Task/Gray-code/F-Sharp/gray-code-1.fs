// Functıons to translate bınary to grey code and vv. Nigel Galloway: December 7th., 2018
let grayCode,invGrayCode=let fN g (n:uint8)=n^^^(n>>>g) in ((fN 1),(fN 1>>fN 2>>fN 4))
